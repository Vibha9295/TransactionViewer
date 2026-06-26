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
    
    @Test("Posted date falls back to em dash when nil")
    func postedDateFallback() {
        #expect(Transaction.makeMock().displayPostedDate == "—")
        #expect(Transaction.makeMock(postedDate: "2026-06-25").displayPostedDate == "2026-06-25")
    }

    @Test("From account falls back to placeholder when nil or blank")
    func fromAccountFallback() {
        #expect(Transaction.makeMock(fromAccount: nil).displayFromAccount == "Unknown account")
        #expect(Transaction.makeMock(fromAccount: "  ").displayFromAccount == "Unknown account")
        #expect(Transaction.makeMock(fromAccount: "Chequing").displayFromAccount == "Chequing")
    }

    @Test("Amount formats correctly with currency code")
    func amountFormatted() {
        let amount = Amount(value: 42.50, currency: "CAD")
        // just check it contains the value — exact format is locale-dependent
        #expect(amount.formatted.contains("42.50") || amount.formatted.contains("42,50"))
    }

    @Test("Credit and debit types decode from raw strings")
    func transactionTypeDecoding() throws {
        let creditJSON = #""CREDIT""#.data(using: .utf8)!
        let debitJSON  = #""DEBIT""#.data(using: .utf8)!

        #expect(try JSONDecoder().decode(TransactionType.self, from: creditJSON) == .credit)
        #expect(try JSONDecoder().decode(TransactionType.self, from: debitJSON)  == .debit)
    }
}

// MARK: - Fixtures

extension Transaction {
    static func makeMock(
        key: String = "test_key",
        type: TransactionType = .debit,
        merchantName: String? = nil,
        fromCardNumber: String? = nil,
        fromAccount: String? = "Main Checking",
        postedDate: String? = nil
    ) -> Transaction {
        Transaction(
            key: key,
            type: type,
            merchantName: merchantName,
            description: nil,
            amount: Amount(value: 0.0, currency: "CAD"),
            postedDate: postedDate,
            fromAccount: fromAccount,
            fromCardNumber: fromCardNumber
        )
    }
}
