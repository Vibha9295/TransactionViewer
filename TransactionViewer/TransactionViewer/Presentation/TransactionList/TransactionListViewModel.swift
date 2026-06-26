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
    
    enum State {
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
        state = .loading
        state = .loaded([])
    }
}
