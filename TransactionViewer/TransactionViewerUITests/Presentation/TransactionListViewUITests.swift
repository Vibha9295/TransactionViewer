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

        let detailScreen = app.otherElements["transaction_detail_screen"]
        XCTAssertTrue(
            detailScreen.waitForExistence(timeout: 3),
            "Detail screen did not appear after tapping a row."
        )
    }

    func testListIsScrollable() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        list.swipeUp()
        XCTAssertTrue(list.exists, "List disappeared after swipe.")
    }
    
    /// Verifies the error state and retry flow.
    /// Requires a separate launch argument that makes MockTransactionService throw.
    func testErrorStateShowsRetryButton() throws {
        app.terminate()
        app.launchArguments = ["-UITestMode", "-UITestErrorMode"]
        app.launch()
        let retryButton = app.buttons["transactions_retry_button"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 5), "Retry button did not appear in error state.")

        // Confirm the button is hittable (not disabled).
        XCTAssertTrue(retryButton.isHittable, "Retry button exists but is not hittable.")
        retryButton.tap()
    }
}
