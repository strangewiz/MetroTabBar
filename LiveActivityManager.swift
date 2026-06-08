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
    private let locationManager = LocationManager()

    /// Store current state for UI
    var isTracking: Bool {
        activeActivity != nil
    }

    var trackingStation: Station?
    var targetLines: [String] = []
    var directionGroup: String = ""

    /// Set of currently skipped trains to implement "I Missed the Train" logic
    private var skippedTrains: Set<SkippedTrain> = []

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    private init() {}

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
                let content = ActivityContent(state: initialState, staleDate: nil)
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

    func incrementMissedTrain() {
        guard let station = trackingStation else { return }

        Task {
            do {
                let predictions = try await WMATAClient.shared.fetchPredictions(for: station.id)
                let now = Date()

                // Keep only unexpired skips when processing the predictions list
                let activeSkips = skippedTrains.filter { $0.expectedArrival.addingTimeInterval(120) > now }

                // Find the first train in predictions that is not currently skipped
                let processed = Self.processPredictions(predictions, lines: targetLines, direction: directionGroup, skippedTrains: activeSkips, now: now)

                if let trainToSkip = processed.first {
                    let minVal = Self.parseMinutes(trainToSkip.min)
                    // Compute expected arrival (use 0 for ARR/BRD/DLY/-- fallback)
                    let minutesToAdd = (minVal == 999) ? 0 : minVal
                    let expectedArrival = now.addingTimeInterval(Double(minutesToAdd) * 60)

                    skippedTrains.insert(SkippedTrain(
                        line: trainToSkip.line,
                        destinationCode: trainToSkip.destinationCode ?? "",
                        group: trainToSkip.group,
                        expectedArrival: expectedArrival
                    ))
                }

                triggerUpdate()
            } catch {
                triggerUpdate()
            }
        }
    }

    private func triggerUpdate() {
        guard let activity = activeActivity, let station = trackingStation else { return }
        Task {
            let updatedState = await fetchUpdatedState(stationCode: station.id, lines: targetLines, direction: directionGroup)
            let content = ActivityContent(state: updatedState, staleDate: nil)
            await activity.update(content)
        }
    }

    private func startPolling() {
        trackingTask = Task {
            while !Task.isCancelled {
                // Poll every 30 seconds
                do {
                    try await Task.sleep(for: .seconds(30))
                } catch {
                    break
                }

                guard let station = trackingStation else { break }
                let state = await fetchUpdatedState(stationCode: station.id, lines: targetLines, direction: directionGroup)

                if let activity = activeActivity {
                    let content = ActivityContent(state: state, staleDate: nil)
                    await activity.update(content)
                }
            }
        }
    }

    private func fetchUpdatedState(stationCode: String, lines: [String], direction: String) async -> TrainTrackingAttributes.ContentState {
        do {
            let predictions = try await WMATAClient.shared.fetchPredictions(for: stationCode)

            // Clean up expired skips (arrival time passed by more than 2 minutes)
            let now = Date()
            skippedTrains = skippedTrains.filter { $0.expectedArrival.addingTimeInterval(120) > now }

            let activePredictions = Self.processPredictions(predictions, lines: lines, direction: direction, skippedTrains: skippedTrains, now: now)

            let nextTrain: WMATATrainPrediction? = activePredictions.indices.contains(0) ? activePredictions[0] : nil
            let followingTrain: WMATATrainPrediction? = activePredictions.indices.contains(1) ? activePredictions[1] : nil
            let thirdTrain: WMATATrainPrediction? = activePredictions.indices.contains(2) ? activePredictions[2] : nil

            let nextMin = nextTrain?.min ?? "--"
            let nextDest = nextTrain?.destinationName ?? "No Train"

            let followingMin = followingTrain?.min ?? "--"
            let followingDest = followingTrain?.destinationName ?? "No Train"

            let thirdMin = thirdTrain?.min ?? "--"
            let thirdDest = thirdTrain?.destinationName ?? "No Train"

            var status: String? = nil
            if nextTrain != nil {
                status = "Updated \(formattedCurrentTime())"
            } else {
                status = "No upcoming trains found"
            }

            return TrainTrackingAttributes.ContentState(
                nextTrainTime: nextMin == "ARR" || nextMin == "BRD" ? nextMin : "\(nextMin) min",
                followingTrainTime: followingMin == "ARR" || followingMin == "BRD" ? followingMin : "\(followingMin) min",
                thirdTrainTime: thirdMin == "ARR" || thirdMin == "BRD" ? thirdMin : "\(thirdMin) min",
                nextTrainDestination: nextDest,
                followingTrainDestination: followingDest,
                thirdTrainDestination: thirdDest,
                nextTrainLineCode: nextTrain?.line ?? "",
                followingTrainLineCode: followingTrain?.line ?? "",
                thirdTrainLineCode: thirdTrain?.line ?? "",
                statusMessage: status
            )

        } catch {
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

    // MARK: - Unit-Testable Predictions Processing Logic

    static func parseMinutes(_ minStr: String) -> Int {
        if minStr == "ARR" || minStr == "BRD" {
            return 0
        }
        if minStr == "DLY" || minStr == "--" {
            return 999
        }
        return Int(minStr) ?? 999
    }

    static func processPredictions(
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
