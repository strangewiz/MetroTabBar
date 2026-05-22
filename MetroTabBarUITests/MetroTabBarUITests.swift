//
//  MetroTabBarUITests.swift
//  MetroTabBarUITests
//
//  Created by Justin Cohen on 5/22/26.
//

import XCTest

final class MetroTabBarUITests: XCTestCase {
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // Launch the application to reset state (since iOS UI tests can have persisted UserDefaults,
        // we can pass a launch argument to clear state or just perform normal actions).
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    @MainActor
    func testFavoriteStationFlow() {
        let app = XCUIApplication()

        // 1. Verify we start on the Favorites tab and the empty state is displayed
        let emptyStateText = app.staticTexts["No Favorites Yet"]
        XCTAssertTrue(emptyStateText.waitForExistence(timeout: 5), "Empty favorites state should be displayed on first launch")

        // 2. Tap "Browse All Stations" to switch to the Stations tab
        let browseButton = app.buttons["Browse All Stations"]
        XCTAssertTrue(browseButton.exists, "Browse All Stations button should be present")
        browseButton.tap()

        // 3. Verify we successfully switched to the Stations list tab
        let metroNavBar = app.navigationBars["DC Metro"]
        XCTAssertTrue(metroNavBar.waitForExistence(timeout: 5), "Stations list navigation bar should appear")

        // 4. Tap the search field and search for "Addison"
        let searchField = app.searchFields["Search stations"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "Search field should exist")
        searchField.tap()
        searchField.typeText("Addison")

        // 5. Tap the matching row for "Addison Rd"
        let stationRow = app.staticTexts["Addison Rd"]
        XCTAssertTrue(stationRow.waitForExistence(timeout: 5), "Addison Rd cell should be visible after search")
        stationRow.tap()

        // 6. Verify we navigated to the Station Detail view
        let detailNavBar = app.navigationBars["Addison Rd"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 5), "Station detail page should open for Addison Rd")

        // 7. Favorite the station using our custom accessibility identifier
        let favoriteButton = app.buttons["favorite_button"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Favorite/star button should be present")

        // Verify current label is Add to Favorites
        XCTAssertEqual(favoriteButton.label, "Add to Favorites")
        favoriteButton.tap()

        // 8. Go back to the stations list
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        backButton.tap()

        // 9. Tap the Favorites tab button (Tab index 0) to return
        let favoritesTabButton = app.tabBars.buttons.element(boundBy: 0)
        XCTAssertTrue(favoritesTabButton.waitForExistence(timeout: 5), "Favorites tab bar button should exist")
        favoritesTabButton.tap()

        // 10. Verify the favorited station is now listed in the Favorites view
        let favoritedCell = app.staticTexts["Addison Rd"]
        XCTAssertTrue(favoritedCell.waitForExistence(timeout: 5), "Addison Rd should now be listed on the Favorites tab")

        // 11. Tap on the favorited station row to open detail view again
        favoritedCell.tap()

        // 12. Remove it from favorites
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Favorite button should exist on detail page")
        XCTAssertEqual(favoriteButton.label, "Remove from Favorites")
        favoriteButton.tap()

        // 13. Navigate back to Favorites tab
        backButton.tap()

        // 14. Verify that the empty state is shown again
        XCTAssertTrue(emptyStateText.waitForExistence(timeout: 5), "Empty state should be visible again after removing the favorite")
    }
}
