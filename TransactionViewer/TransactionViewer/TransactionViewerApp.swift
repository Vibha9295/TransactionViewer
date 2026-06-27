//
//  TransactionViewerApp.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

@main
struct TransactionViewerApp: App {
    var body: some Scene {
        WindowGroup {
            TransactionListView(viewModel: makeViewModel())
        }
    }

    private func makeViewModel() -> TransactionListViewModel {
        #if DEBUG
        if CommandLine.arguments.contains("-UITestMode") {
            return TransactionListViewModel(service: MockTransactionService())
        }
        #endif
        return TransactionListViewModel(service: TransactionService())
    }
}

// MARK: - Mock (Debug / Tests only)

#if DEBUG
// Only used by UI tests and Xcode previews. @unchecked is safe here because
// this type is only ever written during test setup, never concurrently.
final class MockTransactionService: TransactionServiceProtocol, @unchecked Sendable {

    func fetchTransactions() async throws -> [Transaction] {
        [
            Transaction(
                key: "mock_001",
                type: .debit,
                merchantName: "Tim Hortons",
                description: "Double double",
                amount: Amount(value: 4.75, currency: "CAD"),
                postedDate: "2026-06-25",
                fromAccount: "Chequing",
                fromCardNumber: "4111111111111234"
            ),
            Transaction(
                key: "mock_002",
                type: .credit,
                merchantName: "Payroll",
                description: nil,
                amount: Amount(value: 2200.00, currency: "CAD"),
                postedDate: "2026-06-20",
                fromAccount: "Chequing",
                fromCardNumber: nil
            ),
            Transaction(
                key: "mock_003",
                type: .debit,
                merchantName: "Sobeys",
                description: "Weekly groceries",
                amount: Amount(value: 112.38, currency: "CAD"),
                postedDate: "2026-06-18",
                fromAccount: "Chequing",
                fromCardNumber: "4111111111111234"
            )
        ]
    }
}
#endif
