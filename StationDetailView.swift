import SwiftUI

struct StationDetailView: View {
    let station: Station
    @Environment(FavoritesManager.self) var favoritesManager
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var reloadID = 0

    private let activityManager = LiveActivityManager.shared
    @State private var trackingOptions: [TrackingOption] = []

    struct TrackingOption: Identifiable {
        let id = UUID()
        let directionGroup: String
        let label: String
        let lines: [String]
    }

    var body: some View {
        ZStack {
            if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)

                    Text("Connection Failed")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text(error)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button(action: {
                        self.errorMessage = nil
                        self.isLoading = true
                        self.reloadID += 1
                        self.loadTrackingOptions()
                    }) {
                        Label("Try Again", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 40)
                    }
                }
            } else {
                WKWebViewWrapper(
                    url: station.webURL,
                    isLocalHTML: false,
                    isLoading: $isLoading,
                    errorMessage: $errorMessage
                )
                .id(reloadID)
                .ignoresSafeArea(edges: .bottom)
                .overlay {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .shadow(radius: 10)
                            )
                    }
                }
            }
        }
        .navigationTitle(station.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Live Activity Tracking Button
                if activityManager.isTracking && activityManager.trackingStation == station {
                    Button(action: {
                        activityManager.stopTracking()
                    }) {
                        Image(systemName: "timer")
                            .foregroundStyle(.orange)
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Stop Tracking Train")
                } else {
                    Menu {
                        if trackingOptions.isEmpty {
                            Button(action: {}) {
                                Label("Loading directions...", systemImage: "arrow.clockwise")
                            }
                            .disabled(true)
                        } else {
                            ForEach(trackingOptions) { option in
                                Button(action: {
                                    activityManager.startTracking(station: station, lines: option.lines, directionGroup: option.directionGroup)
                                }) {
                                    Text(option.label)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "timer")
                            .foregroundStyle(trackingOptions.isEmpty ? Color.secondary : Color.blue)
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Track Train Arrivals")
                }

                // Favorite Button
                let isFav = favoritesManager.isFavorite(station)
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(station)
                    }
                }) {
                    Image(systemName: isFav ? "star.fill" : "star")
                        .foregroundStyle(isFav ? .orange : .gray)
                        .imageScale(.large)
                        .scaleEffect(isFav ? 1.2 : 1.0)
                }
                .accessibilityIdentifier("favorite_button")
                .accessibilityLabel(isFav ? "Remove from Favorites" : "Add to Favorites")
            }
        }
        .onAppear {
            loadTrackingOptions()
        }
    }

    private func loadTrackingOptions() {
        Task {
            do {
                let subCodes = station.id.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                var options: [TrackingOption] = []

                for subCode in subCodes {
                    guard !subCode.isEmpty else { continue }
                    let predictions = try await WMATAClient.shared.fetchPredictions(for: subCode)

                    // Group by group ("1" or "2")
                    var group1Destinations = Set<String>()
                    var group1Lines = Set<String>()
                    var group2Destinations = Set<String>()
                    var group2Lines = Set<String>()

                    for p in predictions {
                        if p.group == "1" {
                            group1Destinations.insert(p.destination)
                            group1Lines.insert(p.line)
                        } else if p.group == "2" {
                            group2Destinations.insert(p.destination)
                            group2Lines.insert(p.line)
                        }
                    }

                    // If no predictions were found for this subcode, use fallback lines derived from station lines
                    let subCodeLines = group1Lines.union(group2Lines)
                    let activeLines = subCodeLines.isEmpty ? Set(station.lineCodes) : subCodeLines
                    let linePrefix = lineGroupName(for: activeLines)

                    if !group1Destinations.isEmpty {
                        let destList = Array(group1Destinations).sorted().joined(separator: " / ")
                        options.append(TrackingOption(
                            directionGroup: "1",
                            label: "\(linePrefix): Towards \(destList)",
                            lines: Array(group1Lines)
                        ))
                    }

                    if !group2Destinations.isEmpty {
                        let destList = Array(group2Destinations).sorted().joined(separator: " / ")
                        options.append(TrackingOption(
                            directionGroup: "2",
                            label: "\(linePrefix): Towards \(destList)",
                            lines: Array(group2Lines)
                        ))
                    }
                }

                // If no options were resolved (e.g. late night), build fallback configurations
                if options.isEmpty {
                    await MainActor.run {
                        buildFallbackOptions()
                    }
                } else {
                    await MainActor.run {
                        self.trackingOptions = options
                    }
                }
            } catch {
                await MainActor.run {
                    buildFallbackOptions()
                }
            }
        }
    }

    private func lineGroupName(for lines: Set<String>) -> String {
        let sortedLines = Array(lines).sorted()
        let names = sortedLines.map { code -> String in
            switch code.uppercased() {
            case "RD": return "Red"
            case "OR": return "Orange"
            case "YL": return "Yellow"
            case "GR": return "Green"
            case "BL": return "Blue"
            case "SV": return "Silver"
            default: return code
            }
        }
        return names.joined(separator: "/")
    }

    private func buildFallbackOptions() {
        let subCodes = station.id.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        var options: [TrackingOption] = []

        for subCode in subCodes {
            let lines: [String]
            if subCode == "A01" || subCode.hasPrefix("A") || subCode.hasPrefix("B") {
                lines = ["RD"]
            } else {
                lines = station.lineCodes.filter { $0 != "RD" }
            }

            if !lines.isEmpty {
                let linePrefix = lineGroupName(for: Set(lines))
                options.append(TrackingOption(directionGroup: "1", label: "\(linePrefix): Direction 1", lines: lines))
                options.append(TrackingOption(directionGroup: "2", label: "\(linePrefix): Direction 2", lines: lines))
            }
        }

        if options.isEmpty {
            let lines = station.lineCodes
            if !lines.isEmpty {
                let linePrefix = lineGroupName(for: Set(lines))
                options = [
                    TrackingOption(directionGroup: "1", label: "\(linePrefix): Direction 1", lines: lines),
                    TrackingOption(directionGroup: "2", label: "\(linePrefix): Direction 2", lines: lines),
                ]
            }
        }

        trackingOptions = options
    }
}
