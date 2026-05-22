import SwiftUI

@main
struct MetroTabBarApp: App {
    @State private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesManager)
        }
    }
}
