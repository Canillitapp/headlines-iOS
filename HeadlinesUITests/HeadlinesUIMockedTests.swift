//
//  HeadlinesUITests.swift
//  HeadlinesUITests
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import XCTest

class HeadlinesUIMockedTests: XCTestCase {

    let defaultWaitThreshold = 60.0

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation
        // of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("mockRequests")
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMockedReactions() {
        let app = XCUIApplication()

        //  Go to Reacciones tab
        app.tabBars.buttons["Reacciones"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }

    func testMockedTrendingCards() {
        let app = XCUIApplication()
        let cell = app.collectionViews.cells.element(boundBy: 0)

        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }

    func testPopularNews() {
        let app = XCUIApplication()

        //  Go to Popular tab
        app.tabBars.buttons["Popular"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }

    func testRecentNews() {
        let app = XCUIApplication()

        //  Go to Reciente tab
        app.tabBars.buttons["Reciente"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }

    func testReactionScreenFromTrendingCards() {
        let app = XCUIApplication()
        let cell = app.collectionViews.cells.element(boundBy: 0)

        let exists = NSPredicate(format: "exists == 1")

        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)

        //  Go to news
        cell.tap()

        //  Go to reacciones
        app.tables.buttons["add reaction icon"].tap()

        let reaccionesStaticText = app.navigationBars["Reacciones"].staticTexts["Reacciones"]
        let reaccionesTitleLabelExpectation = expectation(for: exists,
                                                          evaluatedWith: reaccionesStaticText,
                                                          handler: nil)
        wait(for: [reaccionesTitleLabelExpectation], timeout: defaultWaitThreshold)
    }

    func testReactionScreenFromRecentNews() {
        let app = XCUIApplication()

        //  Go to Reciente tab
        app.tabBars.buttons["Reciente"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)

        //  Go to reacciones
        cell.press(forDuration: 10)

        let reaccionesStaticText = app.navigationBars["Reacciones"].staticTexts["Reacciones"]
        let reaccionesTitleLabelExpectation = expectation(for: exists,
                                                          evaluatedWith: reaccionesStaticText,
                                                          handler: nil)
        wait(for: [reaccionesTitleLabelExpectation], timeout: defaultWaitThreshold)
    }

    func testReactionScreenFromPopularNews() {
        let app = XCUIApplication()

        //  Go to Popular tab
        app.tabBars.buttons["Popular"].tap()

        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)

        //  Go to reacciones
        cell.press(forDuration: 10)

        let reaccionesStaticText = app.navigationBars["Reacciones"].staticTexts["Reacciones"]
        let reaccionesTitleLabelExpectation = expectation(for: exists,
                                                          evaluatedWith: reaccionesStaticText,
                                                          handler: nil)
        wait(for: [reaccionesTitleLabelExpectation], timeout: defaultWaitThreshold)
    }
}
