//
//  TransactionServiceTests.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Testing
import Foundation
@testable import TransactionViewer

@Suite("Transaction Service Tests")
struct TransactionServiceTests {
    
    @Test("Bundle JSON decodes into a non-empty transaction list")
    func serviceDecodesValidBundleJSON() async throws {
        let transactions = try await TransactionService().fetchTransactions()
        #expect(!transactions.isEmpty)
    }

    @Test("Unknown transaction_type value in bundle JSON throws DecodingError")
    func unknownTransactionTypeThrows() throws {
        let json = """
        {
            "transactions": [{
                "key": "001",
                "transaction_type": "INVALID_TYPE",
                "amount": { "value": 0, "currency": "CAD" }
            }]
        }
        """.data(using: .utf8)!

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(TransactionList.self, from: json)
        }
    }

    @Test("fileNotFound error description mentions the expected filename")
    func fileNotFoundDescription() {
        let error = TransactionServiceError.fileNotFound
        #expect(error.errorDescription?.contains("transaction-list.json") == true)
    }

    @Test("decodingFailed error description includes the underlying error message")
    func decodingFailedDescription() {
        let underlying = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "bad data"])
        let error = TransactionServiceError.decodingFailed(underlying)
        #expect(error.errorDescription?.contains("bad data") == true)
    }
}
