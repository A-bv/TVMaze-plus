//
//  TVMazeAppUITests.swift
//  TVMazeAppUITests
//
//  Created by Alexandre Bevilacqua on 05.11.2026.
//

import XCTest

final class TVMazeAppUITests: XCTestCase {
    private enum Constants {
        static let search = "girls"
        static let addLabel = "Add to favorites"
        static let removeLabel = "Remove from favorites"
        static let favoritesTab = "Favorites"
        static let searchTab = "Search"
        static let deleteLabel = "Delete"
        static let showName = "Girls"
        static let systemSearchClearButton = "_UITextFieldClearButton"
        static let timeout: TimeInterval = 15
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSearchFavoriteAndDeleteFlow() {
        let app = launchedApp()
        openTab(Constants.favoritesTab, in: app)
        let favoritesBefore = app.cells.count

        openTab(Constants.searchTab, in: app)
        search(in: app)
        let addButton = app.buttons[Constants.addLabel].firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: Constants.timeout))
        addButton.tap()
        XCTAssertTrue(app.buttons[Constants.removeLabel].firstMatch.waitForExistence(timeout: Constants.timeout))

        openTab(Constants.favoritesTab, in: app)
        XCTAssertEqual(app.cells.count, favoritesBefore + 1)
        app.cells.firstMatch.swipeLeft()
        app.buttons[Constants.deleteLabel].firstMatch.tap()
        XCTAssertEqual(app.cells.count, favoritesBefore)
    }

    @MainActor
    func testResultsStayAfterComingBackFromAShow() {
        let app = launchedApp()
        search(in: app)
        let showName = app.staticTexts[Constants.showName].firstMatch
        XCTAssertTrue(showName.waitForExistence(timeout: Constants.timeout))
        showName.tap()
        XCTAssertTrue(app.navigationBars[Constants.showName].waitForExistence(timeout: Constants.timeout))

        app.navigationBars.buttons.firstMatch.tap()

        XCTAssertTrue(showName.waitForExistence(timeout: Constants.timeout))
        XCTAssertFalse(app.activityIndicators.firstMatch.exists)
    }

    @MainActor
    func testSearchResultsHaveNoAccessibilityIssues() throws {
        let app = launchedApp()
        search(in: app)
        XCTAssertTrue(app.buttons[Constants.addLabel].firstMatch.waitForExistence(timeout: Constants.timeout))
        try app.performAccessibilityAudit { issue in
            issue.detailedDescription.contains(Constants.systemSearchClearButton)
        }
    }

    @MainActor
    private func launchedApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
        return app
    }

    @MainActor
    private func search(in app: XCUIApplication) {
        let field = app.searchFields.firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: Constants.timeout))
        field.tap()
        field.typeText(Constants.search + "\n")
    }

    @MainActor
    private func openTab(_ name: String, in app: XCUIApplication) {
        let tab = app.tabBars.buttons[name]
        XCTAssertTrue(tab.waitForExistence(timeout: Constants.timeout))
        tab.tap()
    }
}
