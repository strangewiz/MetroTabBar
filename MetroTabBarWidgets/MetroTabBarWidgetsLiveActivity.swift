import ActivityKit
import SwiftUI
import WidgetKit
import AppIntents

@main
struct MetroTabBarWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrainTrackingAttributes.self) { context in
            // Lock screen/banner UI
            VStack(alignment: .leading, spacing: 12) {
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
                VStack(spacing: 8) {
                    // Next Train
                    HStack {
                        Image(systemName: "train.side.front.car")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Next:")
                            .font(.subheadline)
                            .fontWeight(.medium)

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

                        Text(context.state.followingTrainDestination)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Spacer()

                        Text(context.state.followingTrainTime)
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
                    .tint(.secondary.opacity(0.2))
                    .foregroundStyle(.primary)

                    // Boarded Train Button
                    Button(intent: BoardedTrainIntent()) {
                        Label("Boarded", systemImage: "checkmark.circle.fill")
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .foregroundStyle(.white)
                }
            }
            .padding(16)
            .activityBackgroundTint(Color(.systemBackground).opacity(0.8))
            .activitySystemActionForegroundColor(Color.primary)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: "train.side.front.car")
                            .font(.title2)
                            .foregroundStyle(.orange)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(context.state.nextTrainTime)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(context.attributes.stationName)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        HStack {
                            Text("Next: \(context.state.nextTrainDestination)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Spacer()

                            if let status = context.state.statusMessage {
                                Text(status)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }

                        HStack(spacing: 8) {
                            Button(intent: MissedTrainIntent()) {
                                Text("Missed It")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.bordered)
                            .tint(.secondary)

                            Button(intent: BoardedTrainIntent()) {
                                Text("Boarded")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        }
                    }
                }
            } compactLeading: {
                HStack(spacing: 2) {
                    Image(systemName: "train.side.front.car")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text(context.attributes.targetLines.joined(separator: "/"))
                        .font(.caption2)
                        .fontWeight(.bold)
                }
            } compactTrailing: {
                Text(context.state.nextTrainTime)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
            } minimal: {
                Text(context.state.nextTrainTime.replacingOccurrences(of: " min", with: "m"))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.orange)
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
}
