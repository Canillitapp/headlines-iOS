//
//  SnapshotUITests.swift
//  SnapshotUITests
//
//  Created by Ezequiel Becerra on 6/3/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import XCTest

class SnapshotUITests: XCTestCase {
    
    let defaultWaitThreshold = 20.0
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
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
        snapshot("01-trending")
    }
    
    func testPopularNews() {
        let app = XCUIApplication()
        
        //  Go to Popular tab
        app.tabBars.buttons["Popular"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        snapshot("02-popular")
    }
    
    func testRecentNews() {
        let app = XCUIApplication()
        
        //  Go to Reciente tab
        app.tabBars.buttons["Reciente"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        snapshot("03-recent-news")
    }
    
    func testReactions() {
        let app = XCUIApplication()
        
        //  Go to Reacciones tab
        app.tabBars.buttons["Reacciones"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        snapshot("04-reactions")
    }
    
}
