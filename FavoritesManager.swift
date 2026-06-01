import Foundation
import Observation
import SwiftUI

@Observable
class FavoritesManager {
    var favoriteIDs: [String] = [] {
        didSet {
            save()
        }
    }

    init() {
        if ProcessInfo.processInfo.arguments.contains("--uitesting") {
            UserDefaults.standard.removeObject(forKey: "MetroTabBar.Favorites")
        }
        favoriteIDs = Self.loadFavorites()
    }

    func isFavorite(_ station: Station) -> Bool {
        favoriteIDs.contains(station.id)
    }

    func toggleFavorite(_ station: Station) {
        if isFavorite(station) {
            favoriteIDs.removeAll { $0 == station.id }
        } else {
            favoriteIDs.append(station.id)
        }
    }

    func reorder(from source: IndexSet, to destination: Int) {
        favoriteIDs.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        favoriteIDs.remove(atOffsets: offsets)
    }

    private static func loadFavorites() -> [String] {
        // 1. Try to load from modern UserDefaults first
        if let saved = UserDefaults.standard.array(forKey: "MetroTabBar.Favorites") as? [String] {
            return saved
        }

        // 2. Fall back to migrating legacy Documents/favorites file if present
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsURL = paths.first {
            let legacyURL = documentsURL.appendingPathComponent("favorites")
            if FileManager.default.fileExists(atPath: legacyURL.path) {
                do {
                    let data = try Data(contentsOf: legacyURL)
                    if let legacyArray = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSDictionary.self, NSString.self], from: data) as? [[String: Any]] {
                        var importedIDs: [String] = []
                        for dict in legacyArray {
                            if let site = dict["site"] as? String {
                                importedIDs.append(site)
                            }
                        }
                        if !importedIDs.isEmpty {
                            // Clean up legacy file
                            try? FileManager.default.removeItem(at: legacyURL)
                            // Save to modern UserDefaults immediately since we migrated
                            UserDefaults.standard.set(importedIDs, forKey: "MetroTabBar.Favorites")
                            return importedIDs
                        }
                    }
                } catch {
                    #if DEBUG
                        print("Legacy favorites migration failed or no legacy favorites found: \(error)")
                    #endif
                }
            }
        }

        return []
    }

    private func save() {
        UserDefaults.standard.set(favoriteIDs, forKey: "MetroTabBar.Favorites")
    }
}
