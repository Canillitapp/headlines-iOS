//
//  SnapshotUIReviewBannerTests.swift
//  SnapshotUITests
//
//  Created by Ezequiel Becerra on 03/01/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import XCTest
import UIKit

class SnapshotUIReviewBannerTests: XCTestCase {
    
    let defaultWaitThreshold = 60.0
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        
        app.launchArguments.append("mockRequests")
        app.launchArguments.append("mockReviewBannerOn")
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
        snapshot("01-trending-review-banner")
    }
}
