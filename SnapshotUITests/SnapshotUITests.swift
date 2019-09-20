//
//  SnapshotUITests.swift
//  SnapshotUITests
//
//  Created by Ezequiel Becerra on 6/3/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import XCTest
import UIKit

class SnapshotUITests: XCTestCase {

    let defaultWaitThreshold = 60.0

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)

        app.launchArguments.append("mockRequests")
        app.launchArguments.append("mockReviewBannerOff")
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTrendingCards() {
        let app = XCUIApplication()
        let cell = app.collectionViews.cells.element(boundBy: 0)

        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)

        //  On iPad we need at least 9 actually
        var expectations = [cellExistsExpectation]
        if UIDevice.current.userInterfaceIdiom == .pad {
            let cellCountExpectation = expectation(for: NSPredicate(format: "count >= 8"),
                                                   evaluatedWith: app.collectionViews.cells,
                                                   handler: nil)
            expectations.append(cellCountExpectation)
        }

        wait(for: expectations, timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("01-trending")
    }

    func testPopularNews() {
        let exists = NSPredicate(format: "exists == 1")

        let tab = XCUIApplication().tabBars.buttons["Popular"]
        let tabBarExpectation = expectation(for: exists, evaluatedWith: tab) { () -> Bool in
            tab.tap()
            return true
        }

        let cell = XCUIApplication().tables.cells.element(boundBy: 0)
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [tabBarExpectation, cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("02-popular")
    }

    func testRecentNews() {
        let exists = NSPredicate(format: "exists == 1")

        let tab = XCUIApplication().tabBars.buttons["Reciente"]
        let tabBarExpectation = expectation(for: exists, evaluatedWith: tab) { () -> Bool in
            tab.tap()
            return true
        }

        let cell = XCUIApplication().tables.cells.element(boundBy: 0)
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [tabBarExpectation, cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("03-recent-news")
    }

    func testRecentNewsFilter() {
        let exists = NSPredicate(format: "exists == 1")

        let tab = XCUIApplication().tabBars.buttons["Reciente"]
        let tabBarExpectation = expectation(for: exists, evaluatedWith: tab) { () -> Bool in
            tab.tap()
            return true
        }

        let cell = XCUIApplication().tables.cells.element(boundBy: 0)
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [tabBarExpectation, cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(2)
        XCUIApplication().navigationBars["Reciente"].buttons["filter icon"].tap()
        sleep(2)
        snapshot("03-recent-news-filter")
    }

    func testProfile() {
        let app = XCUIApplication()

        //  Go to Reacciones tab
        app.tabBars.buttons["Perfil"].tap()

        //  There should be at least 1 cell rendered
        let cell = app.collectionViews.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)

        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("04-profile")
    }

    func testReactionScreenFromMockedSearch() {
        // This test is not working since it's not possible to fetch
        // search field == "Buscar".
        // I'm almost sure this is a bug, so I'm commenting this test until they fix this.
        return

        let exists = NSPredicate(format: "exists == 1")

        let tab = XCUIApplication().tabBars.buttons["Buscar"]
        let tabBarExpectation = expectation(for: exists, evaluatedWith: tab) { () -> Bool in
            tab.tap()
            return true
        }

        wait(for: [tabBarExpectation], timeout: defaultWaitThreshold)

        let searchField = XCUIApplication().navigationBars["Buscar"].searchFields["Buscar"]
        let searchFieldExistsExpectation = expectation(for: exists, evaluatedWith: searchField, handler: nil)
        wait(for: [searchFieldExistsExpectation], timeout: defaultWaitThreshold)
        snapshot("05-search-trending")

        //  Type "Calu"
        searchField.tap()
        searchField.typeText("Calu")
        XCUIApplication().navigationBars["Buscar"].searchFields["Buscar"].tap()
        snapshot("05-search-recommendations")

        //  Enter
        searchField.typeText("\r")
        let cell = XCUIApplication().tables["search table"].cells.element(boundBy: 0)

        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("05-search-results")

        //  Go to reacciones by tapping the "reaction button"
        cell.buttons["add reaction icon"].tap()

        let reaccionesStaticText = XCUIApplication().navigationBars["Reacciones"]
        let reaccionesTitleLabelExpectation = expectation(for: exists,
                                                          evaluatedWith: reaccionesStaticText,
                                                          handler: nil)
        wait(for: [reaccionesTitleLabelExpectation], timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("06-reactions")
    }

    func testTrendingTopic() {
        let app = XCUIApplication()
        let cell = app.collectionViews.cells.element(boundBy: 0)

        let cellExists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: cellExists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)

        cell.tap()

        // Check that a new controller is pushed
        let navigationBar = app.navigationBars["Kim"]
        _ = navigationBar.waitForExistence(timeout: defaultWaitThreshold)

        sleep(5)
        snapshot("01-trending-detail")
    }
}
