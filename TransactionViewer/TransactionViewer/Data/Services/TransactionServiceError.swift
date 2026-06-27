//
//  TransactionServiceError.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

// MARK: - TransactionServiceError

enum TransactionServiceError: LocalizedError, Sendable {
    case fileNotFound
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "transaction-list.json not found in the app bundle."
        case .decodingFailed(let error):
            return "Failed to decode transactions: \(error.localizedDescription)"
        }
    }
}
