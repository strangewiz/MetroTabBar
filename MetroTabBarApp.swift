import SwiftUI

@main
struct MetroTabBarApp: App {
    @State private var favoritesManager = FavoritesManager()
    @State private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesManager)
                .environment(locationManager)
        }
    }
}
