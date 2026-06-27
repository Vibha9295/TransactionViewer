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
    
    @Test("Merchant name falls back to placeholder when nil or whitespace-only")
    func merchantNameFallback() {
        #expect(Transaction.makeMock(merchantName: nil).displayMerchantName    == "Unknown merchant")
        #expect(Transaction.makeMock(merchantName: "").displayMerchantName     == "Unknown merchant")
        #expect(Transaction.makeMock(merchantName: "   ").displayMerchantName  == "Unknown merchant")
        #expect(Transaction.makeMock(merchantName: "Store").displayMerchantName == "Store")
    }

    @Test("Card suffix shows last four digits; empty string when card is short or absent")
    func cardSuffixFormatting() {
        #expect(Transaction.makeMock(fromCardNumber: "1234567890123456").displayCardSuffix == "(3456)")
        #expect(Transaction.makeMock(fromCardNumber: "123").displayCardSuffix             == "")
        #expect(Transaction.makeMock(fromCardNumber: nil).displayCardSuffix               == "")
    }

    @Test("Posted date falls back to em dash when nil")
    func postedDateFallback() {
        #expect(Transaction.makeMock().displayPostedDate                         == "—")
        #expect(Transaction.makeMock(postedDate: "2026-06-25").displayPostedDate == "2026-06-25")
    }

    @Test("From account falls back to placeholder when nil or whitespace-only")
    func fromAccountFallback() {
        #expect(Transaction.makeMock(fromAccount: nil).displayFromAccount   == "Unknown account")
        #expect(Transaction.makeMock(fromAccount: "  ").displayFromAccount  == "Unknown account")
        #expect(Transaction.makeMock(fromAccount: "Chequing").displayFromAccount == "Chequing")
    }

    @Test("Amount formats to a string that contains the numeric value")
    func amountFormatted() {
        let amount = Amount(value: 42.50, currency: "CAD")
        // Exact format is locale-dependent; just check the number is present.
        #expect(amount.formatted.contains("42.50") || amount.formatted.contains("42,50"))
    }

    @Test("CREDIT and DEBIT raw strings decode to the correct enum cases")
    func transactionTypeDecoding() throws {
        let creditJSON = #""CREDIT""#.data(using: .utf8)!
        let debitJSON  = #""DEBIT""#.data(using: .utf8)!

        #expect(try JSONDecoder().decode(TransactionType.self, from: creditJSON) == .credit)
        #expect(try JSONDecoder().decode(TransactionType.self, from: debitJSON)  == .debit)
    }

    @Test("Unknown transaction_type value throws DecodingError rather than silently returning nil")
    func unknownTransactionTypeThrows() {
        let json = #""UNKNOWN""#.data(using: .utf8)!
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(TransactionType.self, from: json)
        }
    }

    @Test("isCredit returns true only for credit transactions")
    func isCreditFlag() {
        #expect(Transaction.makeMock(type: .credit).type.isCredit == true)
        #expect(Transaction.makeMock(type: .debit).type.isCredit  == false)
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
