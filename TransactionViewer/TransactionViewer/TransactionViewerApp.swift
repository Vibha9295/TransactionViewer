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
        let args = CommandLine.arguments
        if args.contains("-UITestMode") {
            let service = MockTransactionService(
                shouldFail: args.contains("-UITestErrorMode")
            )
            return TransactionListViewModel(service: service)
        }
        #endif
        return TransactionListViewModel(service: TransactionService())
    }
}

// MARK: - Mock (Debug / Tests only)

#if DEBUG
/// Only used by UI tests and Xcode previews.
/// @unchecked is safe here because this type is only written during test setup,
/// never from concurrent contexts.
final class MockTransactionService: TransactionServiceProtocol, @unchecked Sendable {
    
    private let shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func fetchTransactions() async throws -> [Transaction] {
        if shouldFail {
            throw TransactionServiceError.fileNotFound
        }
        return [
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
