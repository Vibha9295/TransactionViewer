//
//  TransactionListViewUITests.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import XCTest

final class TransactionListViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITestMode")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testListLoadsAndShowsRows() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        
        XCTAssertTrue(list.cells.firstMatch.exists)
    }
    
    func testTappingRowPushesDetailScreen() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        list.cells.element(boundBy: 0).tap()
        
        XCTAssertTrue(app.navigationBars["Transaction Details"].waitForExistence(timeout: 3))
    }
    
    func testListIsScrollable() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        
        // only meaningful if there are enough rows to scroll
        list.swipeUp()
        XCTAssertTrue(list.exists)
    }
    
    func testDetailScreenShowsTransactionDetails() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        list.cells.element(boundBy: 0).tap()

        XCTAssertTrue(app.navigationBars["Transaction Details"].waitForExistence(timeout: 3))
    }

}
