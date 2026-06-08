import ActivityKit
import CoreLocation
import Foundation

@Observable
class LiveActivityManager {
    static let shared = LiveActivityManager()

    private(set) var activeActivity: Activity<TrainTrackingAttributes>?
    private var trackingTask: Task<Void, Never>?
    private let locationManager = LocationManager()

    /// Store current state for UI
    var isTracking: Bool {
        activeActivity != nil
    }

    var trackingStation: Station?
    var targetLines: [String] = []
    var directionGroup: String = ""

    /// Missed train counter / offset
    private var missedCount = 0

    private init() {}

    func startTracking(station: Station, lines: [String], directionGroup: String) {
        // Stop any current tracking first
        stopTracking()

        trackingStation = station
        targetLines = lines
        self.directionGroup = directionGroup
        missedCount = 0

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
        Task {
            let initialState = await fetchUpdatedState(stationCode: station.id, lines: lines, direction: directionGroup)

            do {
                let content = ActivityContent(state: initialState, staleDate: nil)
                let activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
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
        missedCount = 0
    }

    func incrementMissedTrain() {
        missedCount += 1
        // Force update immediately
        triggerUpdate()
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

            // Adjust index if user skipped train (missed count)
            let startIndex = missedCount

            let nextTrain: WMATATrainPrediction? = sorted.indices.contains(startIndex) ? sorted[startIndex] : nil
            let followingTrain: WMATATrainPrediction? = sorted.indices.contains(startIndex + 1) ? sorted[startIndex + 1] : nil
            let thirdTrain: WMATATrainPrediction? = sorted.indices.contains(startIndex + 2) ? sorted[startIndex + 2] : nil

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

    private func parseMinutes(_ minStr: String) -> Int {
        if minStr == "ARR" || minStr == "BRD" {
            return 0
        }
        if minStr == "DLY" || minStr == "--" {
            return 999
        }
        return Int(minStr) ?? 999
    }

    private func formattedCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}
