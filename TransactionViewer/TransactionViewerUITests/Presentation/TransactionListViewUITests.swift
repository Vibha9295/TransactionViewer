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
        XCTAssertTrue(list.waitForExistence(timeout: 3), "Transaction list did not appear.")
        XCTAssertTrue(list.cells.firstMatch.exists, "No rows found in transaction list.")
    }

    func testTappingRowNavigatesToDetailScreen() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        list.cells.element(boundBy: 0).tap()

        XCTAssertTrue(
            app.navigationBars["Transaction Details"].waitForExistence(timeout: 3),
            "Detail screen navigation bar did not appear."
        )
    }

    func testListIsScrollable() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        list.swipeUp()
        XCTAssertTrue(list.exists, "List disappeared after swipe.")
    }
}
