//
//  TransactionListViewModel.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

@MainActor
@Observable
final class TransactionListViewModel {
    
    enum State: Sendable {
        case idle
        case loading
        case loaded([Transaction])
        case failed(String)
    }

    private(set) var state: State = .idle
    private let service: any TransactionServiceProtocol

    init(service: any TransactionServiceProtocol = TransactionService()) {
        self.service = service
    }

    func loadTransactions() async {
        // Don't flash a spinner over existing rows during pull-to-refresh.
        if case .loaded = state { } else {
            state = .loading
        }

        do {
            let transactions = try await service.fetchTransactions()
            state = .loaded(transactions)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
