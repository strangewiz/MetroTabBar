import SwiftUI

@main
struct MetroTabBarApp: App {
    @State private var favoritesManager = FavoritesManager()
    @State private var locationManager = LocationManager()

    init() {
        LiveActivityActionRegistry.onMissedTrain = {
            LiveActivityManager.shared.incrementMissedTrain()
        }
        LiveActivityActionRegistry.onBoardedTrain = {
            LiveActivityManager.shared.stopTracking()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesManager)
                .environment(locationManager)
        }
    }
}
