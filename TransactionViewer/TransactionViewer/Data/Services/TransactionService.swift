//
//  TransactionService.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

// MARK: - TransactionServiceProtocol

protocol TransactionServiceProtocol: Sendable {
    func fetchTransactions() async throws -> [Transaction]
}

// MARK: - TransactionService

final class TransactionService: TransactionServiceProtocol, Sendable {
    #if DEBUG
    private let simulatedDelay: UInt64 = 500_000_000
    #else
    private let simulatedDelay: UInt64 = 0
    #endif
    
    func fetchTransactions() async throws -> [Transaction] {
        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: simulatedDelay)
        }
        guard let url = Bundle.main.url(forResource: "transaction-list", withExtension: "json") else {
            throw TransactionServiceError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(TransactionList.self, from: data).transactions
        } catch let error as TransactionServiceError {
            throw error
        } catch {
            throw TransactionServiceError.decodingFailed(error)
        }
    }
}


