//
//  String+Localization.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
import SwiftUI

extension Color {
    static let transactionGreen = Color.green
    static let transactionRed = Color.red
}
