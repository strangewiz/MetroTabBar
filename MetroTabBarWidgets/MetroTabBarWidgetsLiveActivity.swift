import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

@main
struct MetroTabBarWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrainTrackingAttributes.self) { context in
            // Lock screen/banner UI
            VStack(alignment: .leading, spacing: 6) {
                // Header Row
                HStack {
                    Text("🚇 \(context.attributes.stationName)")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    // Display target lines
                    HStack(spacing: 4) {
                        ForEach(context.attributes.targetLines, id: \.self) { lineCode in
                            Text(lineCode)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(lineColor(for: lineCode))
                                .clipShape(Capsule())
                        }
                    }
                }

                Divider()

                // Arrivals Info
                VStack(spacing: 4) {
                    // Next Train
                    HStack {
                        Image(systemName: "train.side.front.car")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Next:")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        if !context.state.nextTrainLineCode.isEmpty {
                            Text(context.state.nextTrainLineCode)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(lineColor(for: context.state.nextTrainLineCode))
                                .clipShape(Capsule())
                        }

                        Text(context.state.nextTrainDestination)
                            .font(.subheadline)
                            .foregroundStyle(.primary)

                        Spacer()

                        Text(context.state.nextTrainTime)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }

                    // Following Train
                    HStack {
                        Image(systemName: "train.side.middle.car")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Then:")
                            .font(.caption)

                        if !context.state.followingTrainLineCode.isEmpty {
                            Text(context.state.followingTrainLineCode)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(lineColor(for: context.state.followingTrainLineCode))
                                .clipShape(Capsule())
                        }

                        Text(context.state.followingTrainDestination)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(context.state.followingTrainTime)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Third Train
                    HStack {
                        Image(systemName: "train.side.middle.car")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("Then:")
                            .font(.caption)

                        if !context.state.thirdTrainLineCode.isEmpty {
                            Text(context.state.thirdTrainLineCode)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(lineColor(for: context.state.thirdTrainLineCode))
                                .clipShape(Capsule())
                        }

                        Text(context.state.thirdTrainDestination)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(context.state.thirdTrainTime)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Divider()

                // Bottom Control / Interactive Buttons
                HStack(spacing: 8) {
                    if let status = context.state.statusMessage {
                        Text(status)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    // Missed Train Button
                    Button(intent: MissedTrainIntent()) {
                        Label("I Missed It", systemImage: "clock.arrow.circlepath")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .tint(.secondary.opacity(0.2))
                    .foregroundStyle(.primary)

                    // Boarded Train Button
                    Button(intent: BoardedTrainIntent()) {
                        Label("Boarded", systemImage: "checkmark.circle.fill")
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .tint(.blue)
                    .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .activityBackgroundTint(Color(.systemBackground).opacity(0.8))
            .activitySystemActionForegroundColor(Color.primary)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "train.side.front.car")
                        .font(.title2)
                        .foregroundStyle(lineColor(for: context.state.nextTrainLineCode))
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.nextTrainTime)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.attributes.stationName)
                            .font(.headline)
                            .lineLimit(1)
                        Text("Next: \(context.state.nextTrainDestination)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        if !context.state.followingTrainDestination.isEmpty && context.state.followingTrainDestination != "No Train" {
                            HStack(spacing: 6) {
                                if !context.state.followingTrainLineCode.isEmpty {
                                    Text(context.state.followingTrainLineCode)
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(lineColor(for: context.state.followingTrainLineCode))
                                        .clipShape(Capsule())
                                }

                                Text("Then: \(context.state.followingTrainDestination) (\(context.state.followingTrainTime))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        HStack(spacing: 8) {
                            if let status = context.state.statusMessage {
                                Text(status)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }

                            Spacer()

                            Button(intent: MissedTrainIntent()) {
                                Text("Missed It")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .tint(.secondary)

                            Button(intent: BoardedTrainIntent()) {
                                Text("Boarded")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                            .tint(.blue)
                        }
                    }
                }
            } compactLeading: {
                HStack(spacing: 4) {
                    Image(systemName: "train.side.front.car")
                        .font(.caption2)
                        .foregroundStyle(lineColor(for: context.state.nextTrainLineCode))
                    Text(compactLeadingText(context: context))
                        .font(.caption2)
                        .fontWeight(.bold)
                }
            } compactTrailing: {
                Text(compactTrailingText(context: context))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            } minimal: {
                let t1 = cleanMin(context.state.nextTrainTime)
                let suffix = (t1 == "ARR" || t1 == "BRD") ? "" : "m"
                Text(t1.isEmpty ? "--" : "\(t1)\(suffix)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(lineColor(for: context.state.nextTrainLineCode))
            }
            .widgetURL(URL(string: "metroapp://track"))
            .keylineTint(Color.orange)
        }
    }

    private func lineColor(for code: String) -> Color {
        switch code.uppercased() {
        case "RD": return .red
        case "OR": return .orange
        case "YL": return .yellow
        case "GR": return .green
        case "BL": return .blue
        case "SV": return .gray
        default: return .primary
        }
    }

    private func compactLeadingText(context: ActivityViewContext<TrainTrackingAttributes>) -> String {
        let t1 = cleanMin(context.state.nextTrainTime)
        if t1.isEmpty { return "--" }
        let prefix = context.attributes.targetLines.count > 1 && !context.state.nextTrainLineCode.isEmpty ? "\(context.state.nextTrainLineCode):" : ""
        let suffix = (t1 == "ARR" || t1 == "BRD") ? "" : "m"
        return "\(prefix)\(t1)\(suffix)"
    }

    private func compactTrailingText(context: ActivityViewContext<TrainTrackingAttributes>) -> String {
        let t2 = cleanMin(context.state.followingTrainTime)
        if t2.isEmpty { return "" }
        let prefix = context.attributes.targetLines.count > 1 && !context.state.followingTrainLineCode.isEmpty ? "\(context.state.followingTrainLineCode):" : ""
        let suffix = (t2 == "ARR" || t2 == "BRD") ? "" : "m"
        return "\(prefix)\(t2)\(suffix)"
    }

    private func cleanMin(_ val: String) -> String {
        let cleaned = val.lowercased()
            .replacingOccurrences(of: " min", with: "")
            .replacingOccurrences(of: " mins", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.isEmpty || cleaned == "--" || cleaned.contains("error") || cleaned.contains("no") {
            return ""
        }
        return cleaned.uppercased()
    }
}
