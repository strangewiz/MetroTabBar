import SwiftUI

struct StationDetailView: View {
    let station: Station
    @Environment(FavoritesManager.self) var favoritesManager
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var reloadID = 0

    var body: some View {
        ZStack {
            if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 64))
                        .foregroundColor(.secondary)

                    Text("Connection Failed")
                        .font(.title3)
                        .fontWeight(.bold)

                    Text(error)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button(action: {
                        self.errorMessage = nil
                        self.isLoading = true
                        self.reloadID += 1
                    }) {
                        Label("Try Again", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
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
            ToolbarItem(placement: .topBarTrailing) {
                let isFav = favoritesManager.isFavorite(station)
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(station)
                    }
                }) {
                    Image(systemName: isFav ? "star.fill" : "star")
                        .foregroundColor(isFav ? .orange : .gray)
                        .imageScale(.large)
                        .scaleEffect(isFav ? 1.2 : 1.0)
                }
                .accessibilityIdentifier("favorite_button")
                .accessibilityLabel(isFav ? "Remove from Favorites" : "Add to Favorites")
            }
        }
    }
}
