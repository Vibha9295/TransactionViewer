//
//  TransactionService.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

protocol TransactionServiceProtocol: Sendable {
    func fetchTransactions() async throws -> [Transaction]
}

final class TransactionService: TransactionServiceProtocol, @unchecked Sendable {
    func fetchTransactions() async throws -> [Transaction] {
        return []
    }
}
