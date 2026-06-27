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

    // 0.5s pause to mimic a real network round-trip in the simulator, remove before prod
    private let simulatedDelay: UInt64 = 500_000_000

    func fetchTransactions() async throws -> [Transaction] {
        try await Task.sleep(nanoseconds: simulatedDelay)

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


