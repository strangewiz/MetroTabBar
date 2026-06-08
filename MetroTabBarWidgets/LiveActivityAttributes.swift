import ActivityKit
import AppIntents
import Foundation

struct TrainTrackingAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        // Dynamic variables that change over time
        var nextTrainTime: String // e.g. "3 Min"
        var followingTrainTime: String // e.g. "7 Min"
        var thirdTrainTime: String // e.g. "11 Min"
        var nextTrainDestination: String // e.g. "Vienna"
        var followingTrainDestination: String // e.g. "Ashburn"
        var thirdTrainDestination: String // e.g. "Vienna"
        var nextTrainLineCode: String // e.g. "OR"
        var followingTrainLineCode: String // e.g. "SV"
        var thirdTrainLineCode: String // e.g. "OR"
        var statusMessage: String? // e.g. "Updated 10:45 PM"
    }

    // Static variables set when the activity starts
    var stationName: String // e.g. "Metro Center"
    var targetLines: [String] // e.g. ["OR", "SV"]
    var directionGroup: String // e.g. "1" (Westbound)
}

/// Registry to delegate widget taps in the main app target without compiling LiveActivityManager in the Widget Extension
enum LiveActivityActionRegistry {
    static var onMissedTrain: (() -> Void)?
    static var onBoardedTrain: (() -> Void)?
}

struct MissedTrainIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "I Missed the Train"

    init() {}

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            LiveActivityActionRegistry.onMissedTrain?()
        }
        return .result()
    }
}

struct BoardedTrainIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "I Boarded the Train"

    init() {}

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            LiveActivityActionRegistry.onBoardedTrain?()
        }
        return .result()
    }
}
