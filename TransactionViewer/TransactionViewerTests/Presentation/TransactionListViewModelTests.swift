//
//  TransactionListViewModelTests.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Testing
import Foundation
@testable import TransactionViewer

@Suite("Transaction List ViewModel Tests")
struct TransactionListViewModelTests {
    
    @MainActor
    @Test("Initial state is idle before any load is triggered")
    func initialStateIsIdle() {
        let vm = TransactionListViewModel(service: MockTransactionService())
        guard case .idle = vm.state else {
            Issue.record("Expected .idle, got \(vm.state)")
            return
        }
    }

    @MainActor
    @Test("Successful fetch transitions to .loaded with the returned transactions")
    func successfulLoad() async {
        let mock = MockTransactionService(result: .success([.makeMock(merchantName: "Coffee Shop")]))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()

        guard case .loaded(let transactions) = vm.state else {
            Issue.record("Expected .loaded, got \(vm.state)")
            return
        }
        #expect(transactions.count == 1)
        #expect(transactions.first?.displayMerchantName == "Coffee Shop")
    }

    @MainActor
    @Test("Service error surfaces as .failed with a non-empty message")
    func failedLoad() async {
        let error = NSError(domain: "Network", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet"])
        let vm = TransactionListViewModel(service: MockTransactionService(result: .failure(error)))

        await vm.loadTransactions()

        guard case .failed(let message) = vm.state else {
            Issue.record("Expected .failed, got \(vm.state)")
            return
        }
        #expect(message == error.localizedDescription)
    }

    @MainActor
    @Test("Pull-to-refresh does not drop back to .loading when data is already visible")
    func pullToRefreshKeepsLoadedState() async {
        let mock = MockTransactionService(result: .success([.makeMock(merchantName: "Groceries")]))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()
        guard case .loaded = vm.state else {
            Issue.record("Precondition: need .loaded before testing refresh")
            return
        }

        // A second load should not overwrite .loaded with .loading, which would
        // flash a spinner over the already-visible rows.
        await vm.loadTransactions()

        guard case .loaded = vm.state else {
            Issue.record("State left .loaded during refresh — spinner would cover existing rows")
            return
        }
    }

    @MainActor
    @Test("Retry after failure recovers to .loaded when the next request succeeds")
    func retryAfterFailureRecovers() async {
        let error = NSError(domain: "Network", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet"])
        let mock = MockTransactionService(result: .failure(error))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()
        guard case .failed = vm.state else {
            Issue.record("Precondition: expected .failed state")
            return
        }

        mock.mockResult = .success([.makeMock(merchantName: "Retry Shop")])
        await vm.loadTransactions()

        guard case .loaded(let transactions) = vm.state else {
            Issue.record("Expected .loaded after retry, got \(vm.state)")
            return
        }
        #expect(transactions.first?.displayMerchantName == "Retry Shop")
    }

    @MainActor
    @Test("Empty response lands in .loaded with an empty array rather than .failed")
    func emptyResponseIsNotAnError() async {
        let vm = TransactionListViewModel(service: MockTransactionService(result: .success([])))

        await vm.loadTransactions()

        guard case .loaded(let transactions) = vm.state else {
            Issue.record("Expected .loaded for empty response, got \(vm.state)")
            return
        }
        #expect(transactions.isEmpty)
    }
}

// MARK: - Test-only Mock Service

// @unchecked is safe here: mockResult is only mutated from test setup code, never from concurrent contexts.
private final class MockTransactionService: TransactionServiceProtocol, @unchecked Sendable {
    var mockResult: Result<[Transaction], Error>

    init(result: Result<[Transaction], Error> = .success([])) {
        self.mockResult = result
    }

    func fetchTransactions() async throws -> [Transaction] {
        try mockResult.get()
    }
}
