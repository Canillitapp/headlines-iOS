//
//  HeadlinesUITests.swift
//  HeadlinesUITests
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import XCTest

class HeadlinesMockedUITests: XCTestCase {

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

    func testMockedProfile() {
        let app = XCUIApplication()
        
        //  Go to Perfil tab
        app.tabBars.buttons["Perfil"].tap()
        
        let cell = app.collectionViews.cells.element(boundBy: 0)
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
    
    func testMockedPopularNews() {
        let app = XCUIApplication()
        
        //  Go to Popular tab
        app.tabBars.buttons["Popular"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }

    func testMockedRecentNews() {
        let app = XCUIApplication()
        
        //  Go to Reciente tab
        app.tabBars.buttons["Reciente"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }
    
    func testReactionScreenFromMockedRecentNews() {
        let app = XCUIApplication()
        
        //  Go to Reciente tab
        app.tabBars.buttons["Reciente"].tap()
        
        let cell = app.tables.cells.element(boundBy: 1)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        
        //  Go to reacciones by tapping the "reaction button"
        cell.buttons["add reaction icon"].tap()
        
        let reaccionesStaticText = app.navigationBars["Reacciones"].otherElements["Reacciones"]
        let reaccionesTitleLabelExpectation = expectation(for: exists,
                                                          evaluatedWith: reaccionesStaticText,
                                                          handler: nil)
        wait(for: [reaccionesTitleLabelExpectation], timeout: defaultWaitThreshold)
    }
    
    func testReactionScreenFromMockedSearch() {
        let app = XCUIApplication()
        
        //  Go to search
        app.tabBars.buttons["Buscar"].tap()
        
        //  Tap search text input
        let buscarSearchField = app.searchFields["Buscar"]
        buscarSearchField.tap()
        
        //  Type "Calu rivero" and ENTER
        buscarSearchField.typeText("Calu rivero\r")
        
        let cell = app.tables["search table"].cells.element(boundBy: 0)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
        
        //  Go to reacciones by tapping the "reaction button"
        cell.buttons["add reaction icon"].tap()
        
        let reaccionesStaticText = app.navigationBars["Reacciones"].otherElements["Reacciones"]
        let reaccionesTitleLabelExpectation = expectation(for: exists,
                                                          evaluatedWith: reaccionesStaticText,
                                                          handler: nil)
        wait(for: [reaccionesTitleLabelExpectation], timeout: defaultWaitThreshold)
    }
    
    func testCategoriesController() {
        let app = XCUIApplication()
        
        // Is a category cell?
        let categoryCell =
            app.collectionViews.collectionViews.cells
                .containing(.staticText, identifier: "Política")
                .children(matching: .other).element
        let categoryCellExists = NSPredicate(format: "exists == 1")
        let categoryCellExistsExpectation = expectation(
            for: categoryCellExists,
            evaluatedWith: categoryCell,
            handler: nil
        )
        wait(for: [categoryCellExistsExpectation], timeout: defaultWaitThreshold)
        
        // Tap the category cell
        categoryCell.tap()
        
        // Does the category cell redirect into a category screen?
        let cell = app.tables.cells.element(boundBy: 1)
        let exists = NSPredicate(format: "exists == 1")
        let cellExistsExpectation = expectation(for: exists, evaluatedWith: cell, handler: nil)
        wait(for: [cellExistsExpectation], timeout: defaultWaitThreshold)
    }
    
    func testInterestsNavigation() {
        let app = XCUIApplication()
        
        //  Go to Reciente tab
        app.tabBars.buttons["Perfil"].tap()
        
        // Check that interests cell exists and tap it
        let cell = app.collectionViews.cells.element(boundBy: 0)
        _ = cell.waitForExistence(timeout: defaultWaitThreshold)
        cell.tap()
        
        // Check that a new controller is pushed and dismissed correctly
        let navigationBar = app.navigationBars["Macri"]
        let navigationExists = navigationBar.waitForExistence(timeout: defaultWaitThreshold)
        XCTAssert(navigationExists)
        
        navigationBar.buttons.element(boundBy: 0).tap()
        XCTAssertFalse(navigationBar.exists)
    }
}
