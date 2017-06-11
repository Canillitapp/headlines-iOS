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
        let app = XCUIApplication()
        
        //  Go to Popular tab
        app.tabBars.buttons["Popular"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(5)
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
        sleep(5)
        snapshot("03-recent-news")
    }
    
    func testReactions() {
        let app = XCUIApplication()
        
        //  Go to Reacciones tab
        app.tabBars.buttons["Reacciones"].tap()
        
        //  There should be at least 1 cell rendered
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        sleep(5)
        snapshot("04-reactions")
    }
    
}
