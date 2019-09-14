//
//  HeadlinesUITests.swift
//  HeadlinesUITests
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import XCTest

class HeadlinesUITests: XCTestCase {

    let defaultWaitThreshold = 60.0

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation
        // of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
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
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
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
    }
}
