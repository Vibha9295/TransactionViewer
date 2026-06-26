//
//  Transaction.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

// MARK: - TransactionList

struct TransactionList: Decodable {
    var transactions: [Transaction]
    // CodingKeys not needed — synthesized mapping matches JSON keys exactly
}

// MARK: - Transaction

struct Transaction: Identifiable, Decodable, Hashable, Sendable {

    var id: String { key }

    let key: String
    let type: TransactionType
    let merchantName: String?
    let description: String?
    let amount: Amount
    let postedDate: String?
    let fromAccount: String?
    let fromCardNumber: String?

    enum CodingKeys: String, CodingKey {
        case key
        case type           = "transaction_type"
        case merchantName   = "merchant_name"
        case description
        case amount
        case postedDate     = "posted_date"
        case fromAccount    = "from_account"
        case fromCardNumber = "from_card_number"
    }
}

// MARK: - UI Display Helpers

extension Transaction {
    
    // backend sometimes sends whitespace-only strings, treat those as nil
    nonisolated var displayMerchantName: String {
        let trimmed = merchantName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "Unknown merchant" : trimmed
    }

    nonisolated var displayFromAccount: String {
        let trimmed = fromAccount?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? "Unknown account" : trimmed
    }

    nonisolated var displayPostedDate: String {
        postedDate ?? "—" // dash looks cleaner than "N/A" or leaving it blank
    }

    nonisolated var displayCardSuffix: String {
        guard let card = fromCardNumber, card.count >= 4 else { return "" }
        return "(\(card.suffix(4)))"
    }
}

// MARK: - TransactionType

enum TransactionType: String, Decodable, Hashable, Sendable {
    case credit = "CREDIT"
    case debit  = "DEBIT"

    // default RawRepresentable init silently returns nil on unknown values, which swallows bugs. throwing here makes bad payloads visible early.
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        guard let value = TransactionType(rawValue: raw) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unrecognised transaction_type: '\(raw)'"
            )
        }
        self = value
    }
}

// MARK: - Amount

struct Amount: Decodable, Hashable, Sendable {
    let value: Double
    let currency: String

    var formatted: String {
        value.formatted(.currency(code: currency))
    }
}
