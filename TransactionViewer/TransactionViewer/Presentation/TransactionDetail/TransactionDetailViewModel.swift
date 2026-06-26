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

    // always success for now — will need to handle pending/failed states
    // once the API adds a transaction status field
    var statusIcon: String { "success-icon" }

    func toggleTooltip() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isTooltipExpanded.toggle()
        }
    }
}
