//
//  TransactionTests.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Testing
import Foundation
@testable import TransactionViewer

@Suite("Transaction Model Tests")
struct TransactionTests {

    @Test("Merchant name falls back to placeholder when nil or blank")
    func merchantNameFallback() {
        // all three of these should hit the same fallback path
        #expect(Transaction.makeMock(merchantName: nil).displayMerchantName  == "Unknown merchant")
        #expect(Transaction.makeMock(merchantName: "").displayMerchantName   == "Unknown merchant")
        #expect(Transaction.makeMock(merchantName: "   ").displayMerchantName == "Unknown merchant")
        #expect(Transaction.makeMock(merchantName: "Store").displayMerchantName == "Store")
    }

    @Test("Card suffix shows last four digits, empty string when card is short or absent")
    func cardSuffixFormatting() {
        #expect(Transaction.makeMock(fromCardNumber: "1234567890123456").displayCardSuffix == "(3456)")
        #expect(Transaction.makeMock(fromCardNumber: "123").displayCardSuffix == "")
        #expect(Transaction.makeMock(fromCardNumber: nil).displayCardSuffix  == "")
    }
}

// MARK: - Fixtures

extension Transaction {
    static func makeMock(
        merchantName: String? = nil,
        fromCardNumber: String? = nil
    ) -> Transaction {
        Transaction(
            key: "test_key",
            type: .debit,
            merchantName: merchantName,
            description: nil,
            amount: Amount(value: 0.0, currency: "CAD"),
            postedDate: nil,
            fromAccount: "Main Checking",
            fromCardNumber: fromCardNumber
        )
    }
}
