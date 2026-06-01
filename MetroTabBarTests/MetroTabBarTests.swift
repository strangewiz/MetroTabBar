//
//  MetroTabBarTests.swift
//  MetroTabBarTests
//
//  Created by Justin Cohen on 5/22/26.
//

import CoreLocation
@testable import MetroTabBar
import XCTest

final class MetroTabBarTests: XCTestCase {
    private let favoritesKey = "MetroTabBar.Favorites"

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Start each test with clean user defaults
        UserDefaults.standard.removeObject(forKey: favoritesKey)

        // Clean up legacy favorites file if any exists
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsURL = paths.first {
            let legacyURL = documentsURL.appendingPathComponent("favorites")
            try? FileManager.default.removeItem(at: legacyURL)
        }
    }

    override func tearDownWithError() throws {
        // Clean up user defaults after each test
        UserDefaults.standard.removeObject(forKey: favoritesKey)

        // Clean up legacy favorites file if any exists
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let documentsURL = paths.first {
            let legacyURL = documentsURL.appendingPathComponent("favorites")
            try? FileManager.default.removeItem(at: legacyURL)
        }
        try super.tearDownWithError()
    }

    func testStationWebName() {
        let station1 = Station(id: "G03", name: "Addison Rd", colorImageName: "b", lat: 0, lon: 0)
        XCTAssertEqual(station1.webName, "addison-rd")

        let station2 = Station(id: "F02", name: "Archives", colorImageName: "gy", lat: 0, lon: 0)
        XCTAssertEqual(station2.webName, "archives")

        let station3 = Station(id: "E09", name: "College Park-U of MD", colorImageName: "g", lat: 0, lon: 0)
        XCTAssertEqual(station3.webName, "college-park-u-of-md")
    }

    func testStationEqualityAndHashing() {
        let station1 = Station(id: "G03", name: "Addison Rd", colorImageName: "b", lat: 0, lon: 0)
        let station2 = Station(id: "G03", name: "Different Name", colorImageName: "r", lat: 0, lon: 0)
        let station3 = Station(id: "F06", name: "Anacostia", colorImageName: "g", lat: 0, lon: 0)

        XCTAssertEqual(station1, station2)
        XCTAssertNotEqual(station1, station3)
        XCTAssertEqual(station1.hashValue, station2.hashValue)
    }

    func testStationPrecomputedCollections() {
        XCTAssertFalse(Station.allStations.isEmpty)
        XCTAssertEqual(Station.allStations.count, Station.allStationsSorted.count)

        // Ensure sorted alphabetically
        for i in 0 ..< (Station.allStationsSorted.count - 1) {
            let current = Station.allStationsSorted[i].name
            let next = Station.allStationsSorted[i + 1].name
            XCTAssertNotEqual(current.localizedStandardCompare(next), .orderedDescending)
        }

        // Ensure grouped stations are valid and ordered
        XCTAssertFalse(Station.groupedStations.isEmpty)
        let firstSection = Station.groupedStations.first
        XCTAssertEqual(firstSection?.letter, "A")
    }

    func testFavoritesManagerCRUD() {
        let manager = FavoritesManager()
        manager.favoriteIDs = [] // ensure empty

        let station = Station.allStations[0] // Addison Rd
        XCTAssertFalse(manager.isFavorite(station))

        // Toggle favorite on
        manager.toggleFavorite(station)
        XCTAssertTrue(manager.isFavorite(station))
        XCTAssertEqual(manager.favoriteIDs, [station.id])

        // Check persistence
        let savedIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String]
        XCTAssertEqual(savedIDs, [station.id])

        // Toggle favorite off
        manager.toggleFavorite(station)
        XCTAssertFalse(manager.isFavorite(station))
        XCTAssertTrue(manager.favoriteIDs.isEmpty)

        // Add multiple
        let station1 = Station.allStations[0]
        let station2 = Station.allStations[1]
        manager.toggleFavorite(station1)
        manager.toggleFavorite(station2)
        XCTAssertEqual(manager.favoriteIDs, [station1.id, station2.id])

        // Reorder
        manager.reorder(from: IndexSet(integer: 0), to: 2) // move first to second
        XCTAssertEqual(manager.favoriteIDs, [station2.id, station1.id])

        // Delete
        manager.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(manager.favoriteIDs, [station1.id])
    }

    func testFavoritesManagerLegacyMigration() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsURL = paths.first else {
            XCTFail("No documents directory found")
            return
        }
        let legacyURL = documentsURL.appendingPathComponent("favorites")

        // Create legacy format array of dictionaries
        let legacyArray: [[String: Any]] = [
            ["site": "G03"],
            ["site": "F06"],
        ]

        do {
            let legacyData = try NSKeyedArchiver.archivedData(withRootObject: legacyArray, requiringSecureCoding: false)
            try legacyData.write(to: legacyURL)
        } catch {
            XCTFail("Failed to write legacy favorites file: \(error)")
            return
        }

        // Initialize manager which should migrate the legacy favorites
        let manager = FavoritesManager()

        XCTAssertEqual(manager.favoriteIDs, ["G03", "F06"])
        XCTAssertFalse(FileManager.default.fileExists(atPath: legacyURL.path))
    }

    func testStationWebURL() {
        let station1 = Station(id: "G03", name: "Addison Rd", colorImageName: "b", lat: 0, lon: 0)
        XCTAssertEqual(station1.webURL, URL(string: "https://www.wmata.com/ridertools/station/addison-rd"))

        let station2 = Station(id: "F03,D03", name: "L'Enfant Plaza", colorImageName: "bogy", lat: 0, lon: 0)
        XCTAssertEqual(station2.webURL, URL(string: "https://www.wmata.com/ridertools/station/l'enfant-plaza"))
    }

    func testStationDistance() throws {
        let addison = Station(id: "G03", name: "Addison Rd", colorImageName: "b", lat: 38.886713, lon: -76.893592)
        XCTAssertNil(addison.distance(to: nil))

        let exactLocation = CLLocation(latitude: 38.886713, longitude: -76.893592)
        let distanceToSelf = addison.distance(to: exactLocation)
        XCTAssertNotNil(distanceToSelf)
        XCTAssertEqual(try XCTUnwrap(distanceToSelf), 0, accuracy: 0.1)

        let anacostiaLocation = CLLocation(latitude: 38.862073, longitude: -76.995398)
        let distanceToAnacostia = addison.distance(to: anacostiaLocation)
        XCTAssertNotNil(distanceToAnacostia)
        XCTAssertEqual(try XCTUnwrap(distanceToAnacostia), 9245.0, accuracy: 50.0)
    }

    func testLocationManagerLifecycle() {
        let locationManager = LocationManager()
        XCTAssertNil(locationManager.location)

        locationManager.startUpdating()
        locationManager.stopUpdating()
    }
}
