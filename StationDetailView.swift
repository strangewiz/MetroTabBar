import SwiftUI

struct StationDetailView: View {
    let station: Station
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var isLoading = true

    var body: some View {
        WKWebViewWrapper(
            url: station.webURL,
            isLocalHTML: false,
            isLoading: $isLoading
        )
        .edgesIgnoringSafeArea(.bottom)
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
        .navigationTitle(station.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesManager.toggleFavorite(station)
                    }
                }) {
                    Image(systemName: favoritesManager.isFavorite(station) ? "star.fill" : "star")
                        .foregroundColor(favoritesManager.isFavorite(station) ? .orange : .gray)
                        .imageScale(.large)
                        .scaleEffect(favoritesManager.isFavorite(station) ? 1.2 : 1.0)
                }
            }
        }
    }
}
