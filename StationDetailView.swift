import SwiftUI

struct StationDetailView: View {
    let station: Station
    @Environment(FavoritesManager.self) var favoritesManager
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var reloadID = 0

    private let activityManager = LiveActivityManager.shared
    @State private var trackingOptions: [TrackingOption] = []

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
                var predictionsBySubcode: [String: [WMATATrainPrediction]] = [:]

                for subCode in subCodes {
                    guard !subCode.isEmpty else { continue }
                    let predictions = try await WMATAClient.shared.fetchPredictions(for: subCode)
                    predictionsBySubcode[subCode] = predictions
                }

                let resolved = WMATAClient.resolveTrackingOptions(for: station, predictionsBySubcode: predictionsBySubcode)

                await MainActor.run {
                    self.trackingOptions = resolved
                }
            } catch {
                let fallback = WMATAClient.resolveTrackingOptions(for: station, predictionsBySubcode: [:])
                await MainActor.run {
                    self.trackingOptions = fallback
                }
            }
        }
    }
}
