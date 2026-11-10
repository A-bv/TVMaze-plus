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
        static let showName = "Girls"
        static let tonightTitle = "On TV tonight"
        static let tomorrowTitlePrefix = "On TV "
        static let floatingBarBlurHeights: CGFloat = 2
        static let timeout: TimeInterval = 15
        static let longPressDuration: TimeInterval = 1.2
        static let appLocale = Locale(identifier: "en_US")
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testTonightShowsTheEveningListingsOfTheChosenDay() {
        let app = launchedApp()
        XCTAssertTrue(app.staticTexts[Constants.tonightTitle].waitForExistence(timeout: Constants.timeout))

        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
        let dayLabel = tomorrow.formatted(Date.FormatStyle(date: .complete, time: .omitted, locale: Constants.appLocale))
        app.switches[dayLabel].firstMatch.tap()

        let weekday = tomorrow.formatted(Date.FormatStyle(locale: Constants.appLocale).weekday(.wide))
        let tomorrowTitle = Constants.tomorrowTitlePrefix + weekday
        let title = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", tomorrowTitle)).firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: Constants.timeout))
    }

    @MainActor
    func testSearchFavoriteAndRemoveFlow() {
        let app = launchedApp()
        openTab(Constants.favoritesTab, in: app)
        removeFavorite(named: Constants.showName, in: app)

        openTab(Constants.searchTab, in: app)
        search(in: app)
        let addButton = app.buttons[Constants.addLabel].firstMatch
        XCTAssertTrue(addButton.waitForExistence(timeout: Constants.timeout))
        addButton.tap()
        XCTAssertTrue(app.buttons[Constants.removeLabel].firstMatch.waitForExistence(timeout: Constants.timeout))

        openTab(Constants.favoritesTab, in: app)
        XCTAssertTrue(app.buttons[Constants.showName].waitForExistence(timeout: Constants.timeout))
        removeFavorite(named: Constants.showName, in: app)
        XCTAssertFalse(app.buttons[Constants.showName].exists)
    }

    @MainActor
    func testResultsStayAfterComingBackFromAShow() {
        let app = launchedApp()
        openTab(Constants.searchTab, in: app)
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
        openTab(Constants.searchTab, in: app)
        search(in: app)
        XCTAssertTrue(app.buttons[Constants.addLabel].firstMatch.waitForExistence(timeout: Constants.timeout))
        let searchBar = app.searchFields.firstMatch.frame
        let floatingBarTop = searchBar.minY - searchBar.height * Constants.floatingBarBlurHeights
        try app.performAccessibilityAudit { issue in
            guard let element = issue.element else { return false }
            return element.frame.maxY > floatingBarTop
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

    @MainActor
    private func removeFavorite(named name: String, in app: XCUIApplication) {
        let poster = app.buttons[name]
        guard poster.exists else { return }
        poster.press(forDuration: Constants.longPressDuration)
        let removeButton = app.buttons[Constants.removeLabel]
        XCTAssertTrue(removeButton.waitForExistence(timeout: Constants.timeout))
        removeButton.tap()
        XCTAssertTrue(poster.waitForNonExistence(timeout: Constants.timeout))
    }
}
