//
//  TransactionDetailViewUITests.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import XCTest

final class TransactionDetailViewUITests: XCTestCase {
    
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

    func testDetailScreenShowsAndTooltipExpandsAndCollapses() throws {
        let list = app.collectionViews["transactions_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5), "Transaction list did not appear.")

        let firstCell = list.cells.firstMatch
        XCTAssertTrue(firstCell.exists, "No tappable row found in the transaction list.")
        firstCell.tap()

        let detailScreen = app.otherElements["transaction_detail_screen"]
        XCTAssertTrue(detailScreen.waitForExistence(timeout: 3), "Detail screen did not appear after tapping a row.")

        // Expand the tooltip.
        let primaryTooltip = app.buttons["tooltip_primary_text"]
        XCTAssertTrue(primaryTooltip.waitForExistence(timeout: 5), "Primary tooltip element not found.")
        primaryTooltip.tap()

        let expandedTooltip = app.buttons["tooltip_expanded_text"]
        XCTAssertTrue(expandedTooltip.waitForExistence(timeout: 4), "Expanded tooltip did not animate in.")

        // Collapse the tooltip and wait for the animation to finish.
        expandedTooltip.tap()
        let collapsed = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: expandedTooltip
        )
        XCTAssertEqual(
            XCTWaiter().wait(for: [collapsed], timeout: 2), .completed,
            "Expanded tooltip did not disappear after collapsing."
        )

        // Dismiss the detail card and confirm we return to the list.
        let closeButton = app.buttons["detail_close_button"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 2), "Close button not found on detail card.")
        closeButton.tap()

        XCTAssertTrue(list.waitForExistence(timeout: 2), "List did not reappear after dismissing detail card.")
    }
}
