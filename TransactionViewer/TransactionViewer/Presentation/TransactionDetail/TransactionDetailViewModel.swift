//
//  TransactionDetailViewModel.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

@MainActor
@Observable
final class TransactionDetailViewModel {
    let transaction: Transaction
    var isTooltipExpanded: Bool = false
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
}
