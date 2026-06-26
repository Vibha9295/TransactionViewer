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

    func testTransactionDetailScreenFlowAndTooltipInteraction() throws {
        // 1. Navigate from list to detail screen
        let transactionList = app.descendants(matching: .any)["transactions_list"]
        XCTAssertTrue(transactionList.waitForExistence(timeout: 5.0), "The main transaction list failed to appear.")
        
        let firstRow = transactionList.cells.firstMatch.exists ?
                       transactionList.cells.firstMatch :
                       transactionList.buttons.firstMatch
        XCTAssertTrue(firstRow.exists, "No tapable transaction row cell was found.")
        firstRow.tap()

        // 2. Verify detail screen container layout via dynamic element scanning
        let detailScreen = app.descendants(matching: .any)["transaction_detail_screen"]
        XCTAssertTrue(detailScreen.waitForExistence(timeout: 3.0), "Navigation to the transaction detail screen failed.")

        // 3. Verify interactive tooltip expand / collapse sequence
        let primaryTooltip = app.descendants(matching: .any)["tooltip_primary_text"]
        XCTAssertTrue(primaryTooltip.waitForExistence(timeout: 5.0), "Primary tooltip element could not be found in the tree hierarchy.")
        primaryTooltip.tap()

        let expandedTooltip = app.descendants(matching: .any)["tooltip_expanded_text"]
        XCTAssertTrue(expandedTooltip.waitForExistence(timeout: 4.0), "Expanded tooltip element failed to animate into view.")

        expandedTooltip.tap()

        // Wait for collapsed animation frame sweep to finalize safely
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: expandedTooltip
        )
        let result = XCTWaiter().wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(result, .completed, "The expanded tooltip text did not dismiss gracefully.")

        // 4. Verify explicit dismissal via the custom close action button
        let closeButton = app.buttons["detail_close_button"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 2.0), "The custom close action button is missing from the card container layout.")
        closeButton.tap()

        // Confirm we are safely back out on the main landing track
        XCTAssertTrue(transactionList.waitForExistence(timeout: 2.0), "Dismissing the detail card failed to return to the list timeline view.")
    }}
