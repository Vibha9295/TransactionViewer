//
//  Transaction.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

struct TransactionList: Decodable {
    let transactions: [Transaction]
}

struct Transaction: Identifiable, Decodable, Hashable {
    var id: String { key }
    let key: String
    let type: TransactionType
    let merchantName: String?
    let amount: Amount
    let postedDate: String?
}

enum TransactionType: String, Decodable, Hashable {
    case credit = "CREDIT"
    case debit  = "DEBIT"
}
import Foundation

struct Amount: Decodable, Hashable {
    let value: Double
    let currency: String
}
