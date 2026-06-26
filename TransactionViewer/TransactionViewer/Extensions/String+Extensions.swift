//
//  String+Extensions.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

extension String {
    // Placeholder for real date parsing once the API date format is confirmed.
    var formattedTransactionDate: String { self }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
