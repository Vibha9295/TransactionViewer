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
    @Test("Starts idle, nothing should trigger a load on init")
    func initialStateIsIdle() {
        let vm = TransactionListViewModel(service: MockTransactionService())
        guard case .idle = vm.state else {
            Issue.record("Expected .idle, got \(vm.state)")
            return
        }
    }

    @MainActor
    @Test("Successful fetch lands in .loaded with the right transactions")
    func successfulLoad() async throws {
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
    @Test("Service error surfaces as .failed with the error message")
    func failedLoad() async {
        let error = NSError(domain: "Network", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet"])
        let mock = MockTransactionService(result: .failure(error))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()

        guard case .failed(let message) = vm.state else {
            Issue.record("Expected .failed, got \(vm.state)")
            return
        }
        #expect(message == error.localizedDescription)
    }

    @MainActor
    @Test("Pull-to-refresh doesn't drop back to .loading while data is visible")
    func pullToRefreshKeepsLoadedState() async {
        let mock = MockTransactionService(result: .success([.makeMock(merchantName: "Groceries")]))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()
        guard case .loaded = vm.state else {
            Issue.record("Precondition: need .loaded before testing refresh")
            return
        }

        // second load should stay in .loaded throughout — the ViewModel
        // explicitly skips .loading when data already exists
        await vm.loadTransactions()

        guard case .loaded = vm.state else {
            Issue.record("State left .loaded during refresh — spinner would cover existing rows")
            return
        }
    }
    
    @MainActor
    @Test("Retry after failure transitions to .loaded on success")
    func retryAfterFailureRecovers() async {
        let error = NSError(domain: "Network", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet"])
        let mock = MockTransactionService(result: .failure(error))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()
        guard case .failed = vm.state else {
            Issue.record("Precondition: expected .failed state")
            return
        }

        // simulate retry with a working service
        mock.mockResult = .success([.makeMock(merchantName: "Retry Shop")])
        await vm.loadTransactions()

        guard case .loaded(let transactions) = vm.state else {
            Issue.record("Expected .loaded after retry, got \(vm.state)")
            return
        }
        #expect(transactions.first?.displayMerchantName == "Retry Shop")
    }

    @MainActor
    @Test("Empty response lands in .loaded with an empty array, not .failed")
    func emptyResponseIsNotAnError() async {
        let mock = MockTransactionService(result: .success([]))
        let vm = TransactionListViewModel(service: mock)

        await vm.loadTransactions()

        guard case .loaded(let transactions) = vm.state else {
            Issue.record("Expected .loaded for empty response, got \(vm.state)")
            return
        }
        #expect(transactions.isEmpty)
    }
}

// MARK: - Mock

// @unchecked because mockResult is mutable — fine here, tests don't run concurrently
private final class MockTransactionService: TransactionServiceProtocol, @unchecked Sendable {
    var mockResult: Result<[Transaction], Error>

    init(result: Result<[Transaction], Error> = .success([])) {
        self.mockResult = result
    }

    func fetchTransactions() async throws -> [Transaction] {
        try mockResult.get()
    }
}
