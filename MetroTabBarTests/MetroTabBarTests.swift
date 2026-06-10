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
        let locationManager = LocationManager.shared
        XCTAssertNil(locationManager.location)

        locationManager.startUpdating()
        locationManager.stopUpdating()
    }

    func testLiveActivityParseMinutes() {
        XCTAssertEqual(LiveActivityManager.parseMinutes("ARR"), 0)
        XCTAssertEqual(LiveActivityManager.parseMinutes("BRD"), 0)
        XCTAssertEqual(LiveActivityManager.parseMinutes("DLY"), 999)
        XCTAssertEqual(LiveActivityManager.parseMinutes("--"), 999)
        XCTAssertEqual(LiveActivityManager.parseMinutes("5"), 5)
        XCTAssertEqual(LiveActivityManager.parseMinutes("12"), 12)
        XCTAssertEqual(LiveActivityManager.parseMinutes("garbage"), 999)
    }

    func testLiveActivityProcessPredictions() {
        let mockPredictions = [
            WMATATrainPrediction(car: "8", destination: "Vienna", destinationCode: "K08", destinationName: "Vienna", group: "2", line: "OR", locationCode: "C01", locationName: "Metro Center", min: "5"),
            WMATATrainPrediction(car: "8", destination: "Shady Grove", destinationCode: "A15", destinationName: "Shady Grove", group: "2", line: "RD", locationCode: "A01", locationName: "Metro Center", min: "2"),
            WMATATrainPrediction(car: "6", destination: "Glenmont", destinationCode: "B11", destinationName: "Glenmont", group: "1", line: "RD", locationCode: "A01", locationName: "Metro Center", min: "ARR"),
            WMATATrainPrediction(car: "8", destination: "Vienna", destinationCode: "K08", destinationName: "Vienna", group: "2", line: "OR", locationCode: "C01", locationName: "Metro Center", min: "DLY"),
        ]

        // Filter for RD, group 2
        let rdGroup2 = LiveActivityManager.processPredictions(mockPredictions, lines: ["RD"], direction: "2", skippedTrains: [])
        XCTAssertEqual(rdGroup2.count, 1)
        XCTAssertEqual(rdGroup2.first?.destinationName, "Shady Grove")
        XCTAssertEqual(rdGroup2.first?.min, "2")

        // Filter for OR, group 2
        let orGroup2 = LiveActivityManager.processPredictions(mockPredictions, lines: ["OR"], direction: "2", skippedTrains: [])
        XCTAssertEqual(orGroup2.count, 2)
        XCTAssertEqual(orGroup2[0].min, "5") // 5 min is sorted before DLY
        XCTAssertEqual(orGroup2[1].min, "DLY")
    }

    func testLiveActivityProcessPredictionsWithSkips() {
        let mockPredictions = [
            WMATATrainPrediction(car: "8", destination: "Vienna", destinationCode: "K08", destinationName: "Vienna", group: "2", line: "OR", locationCode: "C01", locationName: "Metro Center", min: "2"),
            WMATATrainPrediction(car: "8", destination: "Vienna", destinationCode: "K08", destinationName: "Vienna", group: "2", line: "OR", locationCode: "C01", locationName: "Metro Center", min: "5"),
        ]

        let now = Date()
        // Skip the first train (2 min)
        let arrivalTime = now.addingTimeInterval(2 * 60)
        let skipped = SkippedTrain(line: "OR", destinationCode: "K08", group: "2", expectedArrival: arrivalTime)

        let processed = LiveActivityManager.processPredictions(mockPredictions, lines: ["OR"], direction: "2", skippedTrains: [skipped], now: now)

        // The first train (2 min) should be skipped, leaving only the second train (5 min)
        XCTAssertEqual(processed.count, 1)
        XCTAssertEqual(processed.first?.min, "5")

        // Verify that after time passes and the skipped train expected arrival passes (+2 minutes), the skip no longer matches or we clear it.
        // A new train is approaching (2 min away, same line/dest)
        let laterNow = now.addingTimeInterval(4 * 60)
        let newPredictions = [
            WMATATrainPrediction(car: "8", destination: "Vienna", destinationCode: "K08", destinationName: "Vienna", group: "2", line: "OR", locationCode: "C01", locationName: "Metro Center", min: "2"),
        ]

        let processedLater = LiveActivityManager.processPredictions(newPredictions, lines: ["OR"], direction: "2", skippedTrains: [skipped], now: laterNow)
        // Since laterNow is past skipped.expectedArrival + 90 seconds, the skip check should NOT filter it out!
        XCTAssertEqual(processedLater.count, 1)
        XCTAssertEqual(processedLater.first?.min, "2")
    }

    func testResolveTrackingOptionsWithPredictions() {
        let mockStation = Station(id: "A01,C01", name: "Metro Center", colorImageName: "r-o", lat: 38.898314, lon: -77.028078)
        let mockPredictions = [
            "A01": [
                WMATATrainPrediction(car: "8", destination: "Glenmont", destinationCode: "B11", destinationName: "Glenmont", group: "1", line: "RD", locationCode: "A01", locationName: "Metro Center", min: "5"),
                WMATATrainPrediction(car: "8", destination: "Shady Grove", destinationCode: "A15", destinationName: "Shady Grove", group: "2", line: "RD", locationCode: "A01", locationName: "Metro Center", min: "2"),
            ],
            "C01": [
                WMATATrainPrediction(car: "8", destination: "Vienna", destinationCode: "K08", destinationName: "Vienna", group: "2", line: "OR", locationCode: "C01", locationName: "Metro Center", min: "1"),
            ],
        ]

        let resolved = WMATAClient.resolveTrackingOptions(for: mockStation, predictionsBySubcode: mockPredictions)

        // Should resolve three options: 2 for subcode A01 (group 1 & 2), and 1 for C01 (group 2)
        XCTAssertEqual(resolved.count, 3)

        let option1 = resolved.first { $0.directionGroup == "1" && $0.lines.contains("RD") }
        XCTAssertNotNil(option1)
        XCTAssertEqual(option1?.label, "Red: Towards Glenmont")

        let option2 = resolved.first { $0.directionGroup == "2" && $0.lines.contains("RD") }
        XCTAssertNotNil(option2)
        XCTAssertEqual(option2?.label, "Red: Towards Shady Grove")

        let option3 = resolved.first { $0.directionGroup == "2" && $0.lines.contains("OR") }
        XCTAssertNotNil(option3)
        XCTAssertEqual(option3?.label, "Orange: Towards Vienna")
    }

    func testResolveTrackingOptionsFallback() {
        let mockStation = Station(id: "A01", name: "Metro Center", colorImageName: "r", lat: 38.898314, lon: -77.028078)
        let resolved = WMATAClient.resolveTrackingOptions(for: mockStation, predictionsBySubcode: [:])

        // Should fallback to Direction 1 and Direction 2 options for Red line
        XCTAssertEqual(resolved.count, 2)
        XCTAssertEqual(resolved[0].label, "Red: Direction 1")
        XCTAssertEqual(resolved[0].directionGroup, "1")
        XCTAssertEqual(resolved[1].label, "Red: Direction 2")
        XCTAssertEqual(resolved[1].directionGroup, "2")
    }
}
