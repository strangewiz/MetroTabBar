import ActivityKit
import CoreLocation
import Foundation

struct SkippedTrain: Hashable {
    let line: String
    let destinationCode: String
    let group: String
    let expectedArrival: Date
}

@Observable
@MainActor
class LiveActivityManager {
    static let shared = LiveActivityManager()

    private(set) var activeActivity: Activity<TrainTrackingAttributes>?
    private var startTask: Task<Void, Never>?
    private var trackingTask: Task<Void, Never>?
    private let locationManager = LocationManager.shared
    private var foregroundObserver: NSObjectProtocol?
    private var backgroundObserver: NSObjectProtocol?

    /// Store current state for UI
    var isTracking: Bool {
        activeActivity != nil
    }

    var trackingStation: Station?
    var targetLines: [String] = []
    var directionGroup: String = ""

    /// Set of currently skipped trains to implement "I Missed the Train" logic
    private var skippedTrains: Set<SkippedTrain> = []

    private var lastFetchedPredictions: [WMATATrainPrediction] = []
    private var lastFetchTime: Date?

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    private init() {
        // Restore active activity on initialization (e.g. if the app is cold-started but a Live Activity is already active)
        if let activity = Activity<TrainTrackingAttributes>.activities.first {
            activeActivity = activity
            // Retrieve station and options from attributes
            trackingStation = Station.allStations.first { $0.name == activity.attributes.stationName }
            targetLines = activity.attributes.targetLines
            directionGroup = activity.attributes.directionGroup

            // Resume background location updates and polling
            locationManager.setBackgroundUpdatesEnabled(true)
            locationManager.startUpdating()
            setupLifecycleObservers()
            startPolling()
        }
    }

    func startTracking(station: Station, lines: [String], directionGroup: String) {
        // Stop any current tracking first
        stopTracking()

        trackingStation = station
        targetLines = lines
        self.directionGroup = directionGroup
        skippedTrains.removeAll()

        // Ensure Live Activities are supported/enabled
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            #if DEBUG
                print("Live Activities are not enabled.")
            #endif
            return
        }

        // Start background location updates to keep app alive in background while walking
        locationManager.setBackgroundUpdatesEnabled(true)
        locationManager.startUpdating()

        let attributes = TrainTrackingAttributes(
            stationName: station.name,
            targetLines: lines,
            directionGroup: directionGroup
        )

        // Fetch initial predictions immediately, then request
        startTask = Task {
            let initialState = await fetchUpdatedState(stationCode: station.id, lines: lines, direction: directionGroup)

            guard !Task.isCancelled else { return }

            do {
                let content = makeActivityContent(state: initialState)
                // Request activity (removed deprecated pushType: nil)
                let activity = try Activity.request(attributes: attributes, content: content)

                guard !Task.isCancelled else {
                    await activity.end(nil, dismissalPolicy: .immediate)
                    return
                }

                self.activeActivity = activity

                #if DEBUG
                    print("Live Activity started successfully: \(activity.id)")
                #endif

                // Listen for lifecycle transitions to force immediate updates
                setupLifecycleObservers()

                // Start polling loop
                startPolling()
            } catch {
                #if DEBUG
                    print("Failed to start Live Activity: \(error.localizedDescription)")
                #endif
                stopTracking()
            }
        }
    }

    func stopTracking() {
        startTask?.cancel()
        startTask = nil

        trackingTask?.cancel()
        trackingTask = nil

        locationManager.stopUpdating()
        locationManager.setBackgroundUpdatesEnabled(false)
        removeLifecycleObservers()

        if let activity = activeActivity {
            Task {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            activeActivity = nil
        }

        trackingStation = nil
        targetLines = []
        directionGroup = ""
        skippedTrains.removeAll()
    }

    private func setupLifecycleObservers() {
        removeLifecycleObservers()

        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.triggerUpdate()
        }

        backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.triggerUpdate()
        }
    }

    private func removeLifecycleObservers() {
        if let observer = foregroundObserver {
            NotificationCenter.default.removeObserver(observer)
            foregroundObserver = nil
        }
        if let observer = backgroundObserver {
            NotificationCenter.default.removeObserver(observer)
            backgroundObserver = nil
        }
    }

    func incrementMissedTrain() {
        let now = Date()

        // Keep only unexpired skips
        skippedTrains = skippedTrains.filter { $0.expectedArrival.addingTimeInterval(120) > now }

        // Find the first train in cached predictions that is not currently skipped
        let processed = Self.processPredictions(lastFetchedPredictions, lines: targetLines, direction: directionGroup, skippedTrains: skippedTrains, now: now)

        if let trainToSkip = processed.first {
            let minVal = Self.parseMinutes(trainToSkip.min)
            let minutesToAdd = (minVal == 999) ? 0 : minVal
            let expectedArrival = now.addingTimeInterval(Double(minutesToAdd) * 60)

            skippedTrains.insert(SkippedTrain(
                line: trainToSkip.line,
                destinationCode: trainToSkip.destinationCode ?? "",
                group: trainToSkip.group,
                expectedArrival: expectedArrival
            ))
        }

        // Update Live Activity locally with the new skip applied, without network calls
        updateLiveActivityLocal()
    }

    private func updateLiveActivityLocal() {
        guard let activity = activeActivity else { return }
        let state = getEstimatedState()
        let content = makeActivityContent(state: state)
        Task {
            await activity.update(content)
        }
    }

    private func triggerUpdate() {
        guard let activity = activeActivity, let station = trackingStation else { return }
        Task {
            let updatedState = await fetchUpdatedState(stationCode: station.id, lines: targetLines, direction: directionGroup)
            let content = makeActivityContent(state: updatedState)
            await activity.update(content)
        }
    }

    private func startPolling() {
        trackingTask = Task {
            while !Task.isCancelled {
                // Poll/update every 60 seconds
                do {
                    try await Task.sleep(for: .seconds(60))
                } catch {
                    break
                }

                guard let station = trackingStation else { break }
                let state = await fetchUpdatedState(stationCode: station.id, lines: targetLines, direction: directionGroup)

                if let activity = activeActivity {
                    let content = makeActivityContent(state: state)
                    await activity.update(content)
                }
            }
        }
    }

    private func makeActivityContent(state: TrainTrackingAttributes.ContentState) -> ActivityContent<TrainTrackingAttributes.ContentState> {
        let staleDate = lastFetchTime?.addingTimeInterval(120)

        var score: Double = 0
        let now = Date()
        let activeSkips = skippedTrains.filter { $0.expectedArrival.addingTimeInterval(120) > now }
        let activePredictions = Self.processPredictions(lastFetchedPredictions, lines: targetLines, direction: directionGroup, skippedTrains: activeSkips, now: now)
        if let nextTrain = activePredictions.first {
            let minutes = Self.parseMinutes(nextTrain.min)
            if minutes <= 3 {
                score = 100
            }
        }

        return ActivityContent(state: state, staleDate: staleDate, relevanceScore: score)
    }

    private func getEstimatedState() -> TrainTrackingAttributes.ContentState {
        guard let station = trackingStation else {
            return TrainTrackingAttributes.ContentState(
                nextTrainTime: "--",
                followingTrainTime: "--",
                thirdTrainTime: "--",
                nextTrainDestination: "Error loading",
                followingTrainDestination: "Error loading",
                thirdTrainDestination: "Error loading",
                nextTrainLineCode: "",
                followingTrainLineCode: "",
                thirdTrainLineCode: "",
                statusMessage: "No active tracking"
            )
        }
        if let lastFetch = lastFetchTime {
            return processAndFormatPredictions(lastFetchedPredictions, lines: targetLines, direction: directionGroup, fetchTime: lastFetch)
        } else {
            return TrainTrackingAttributes.ContentState(
                nextTrainTime: "--",
                followingTrainTime: "--",
                thirdTrainTime: "--",
                nextTrainDestination: "Error loading",
                followingTrainDestination: "Error loading",
                thirdTrainDestination: "Error loading",
                nextTrainLineCode: "",
                followingTrainLineCode: "",
                thirdTrainLineCode: "",
                statusMessage: "Waiting for update"
            )
        }
    }

    private func fetchUpdatedState(stationCode: String, lines: [String], direction: String) async -> TrainTrackingAttributes.ContentState {
        do {
            let predictions = try await WMATAClient.shared.fetchPredictions(for: stationCode)

            lastFetchedPredictions = predictions
            lastFetchTime = Date()

            return processAndFormatPredictions(predictions, lines: lines, direction: direction, fetchTime: lastFetchTime ?? Date())
        } catch {
            if let lastFetch = lastFetchTime, Date().timeIntervalSince(lastFetch) < 300 {
                return processAndFormatPredictions(lastFetchedPredictions, lines: lines, direction: direction, fetchTime: lastFetch)
            }
            return TrainTrackingAttributes.ContentState(
                nextTrainTime: "--",
                followingTrainTime: "--",
                thirdTrainTime: "--",
                nextTrainDestination: "Error loading",
                followingTrainDestination: "Error loading",
                thirdTrainDestination: "Error loading",
                nextTrainLineCode: "",
                followingTrainLineCode: "",
                thirdTrainLineCode: "",
                statusMessage: "Failed to connect to WMATA"
            )
        }
    }

    private func processAndFormatPredictions(
        _ predictions: [WMATATrainPrediction],
        lines: [String],
        direction: String,
        fetchTime: Date
    ) -> TrainTrackingAttributes.ContentState {
        let now = Date()
        let elapsedMinutes = Int(now.timeIntervalSince(fetchTime) / 60.0)

        // Clean up expired skips (arrival time passed by more than 2 minutes)
        skippedTrains = skippedTrains.filter { $0.expectedArrival.addingTimeInterval(120) > now }

        let activePredictions = Self.processPredictions(predictions, lines: lines, direction: direction, skippedTrains: skippedTrains, now: now)

        func estimateMin(_ pred: WMATATrainPrediction?) -> String {
            guard let pred = pred else { return "--" }
            let originalMin = pred.min
            if originalMin == "ARR" || originalMin == "BRD" {
                return originalMin
            }
            let parsed = Self.parseMinutes(originalMin)
            if parsed == 999 {
                return originalMin
            }
            let estimated = parsed - elapsedMinutes
            if estimated <= 0 {
                return "1 min"
            }
            return "\(estimated) min"
        }

        let nextTrain: WMATATrainPrediction? = activePredictions.indices.contains(0) ? activePredictions[0] : nil
        let followingTrain: WMATATrainPrediction? = activePredictions.indices.contains(1) ? activePredictions[1] : nil
        let thirdTrain: WMATATrainPrediction? = activePredictions.indices.contains(2) ? activePredictions[2] : nil

        let nextMin = estimateMin(nextTrain)
        let followingMin = estimateMin(followingTrain)
        let thirdMin = estimateMin(thirdTrain)

        let nextDest = nextTrain?.destinationName ?? "No Train"
        let followingDest = followingTrain?.destinationName ?? "No Train"
        let thirdDest = thirdTrain?.destinationName ?? "No Train"

        var status: String? = nil
        if nextTrain != nil {
            status = "Updated \(formattedCurrentTime())"
        } else {
            status = "No upcoming trains found"
        }

        return TrainTrackingAttributes.ContentState(
            nextTrainTime: nextMin,
            followingTrainTime: followingMin,
            thirdTrainTime: thirdMin,
            nextTrainDestination: nextDest,
            followingTrainDestination: followingDest,
            thirdTrainDestination: thirdDest,
            nextTrainLineCode: nextTrain?.line ?? "",
            followingTrainLineCode: followingTrain?.line ?? "",
            thirdTrainLineCode: thirdTrain?.line ?? "",
            statusMessage: status
        )
    }

    // MARK: - Unit-Testable Predictions Processing Logic

    nonisolated static func parseMinutes(_ minStr: String) -> Int {
        if minStr == "ARR" || minStr == "BRD" {
            return 0
        }
        if minStr == "DLY" || minStr == "--" {
            return 999
        }
        return Int(minStr) ?? 999
    }

    nonisolated static func processPredictions(
        _ predictions: [WMATATrainPrediction],
        lines: [String],
        direction: String,
        skippedTrains: Set<SkippedTrain>,
        now: Date = Date()
    ) -> [WMATATrainPrediction] {
        // Filter predictions by matching line and direction group
        let filtered = predictions.filter { prediction in
            let matchesLine = lines.contains { lineCode in
                prediction.line.uppercased() == lineCode.uppercased()
            }
            let matchesDirection = prediction.group == direction
            return matchesLine && matchesDirection
        }

        // Sort predictions: numeric minutes ascending, ARR/BRD first, delay/none last
        let sorted = filtered.sorted { p1, p2 in
            let m1 = parseMinutes(p1.min)
            let m2 = parseMinutes(p2.min)
            return m1 < m2
        }

        // Filter out skipped trains from predictions
        return sorted.filter { p in
            !skippedTrains.contains { skipped in
                p.line == skipped.line &&
                    (p.destinationCode ?? "") == skipped.destinationCode &&
                    p.group == skipped.group &&
                    abs(now.addingTimeInterval(Double(parseMinutes(p.min)) * 60).timeIntervalSince(skipped.expectedArrival)) < 90
            }
        }
    }

    private func formattedCurrentTime() -> String {
        Self.timeFormatter.string(from: Date())
    }
}
