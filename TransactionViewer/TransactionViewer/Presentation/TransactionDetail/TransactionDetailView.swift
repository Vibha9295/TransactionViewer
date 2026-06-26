//
//  TransactionDetailView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    @State private var viewModel: TransactionDetailViewModel
    
    init(transaction: Transaction) {
        self.transaction = transaction
        _viewModel = State(initialValue: TransactionDetailViewModel(transaction: transaction))
    }
    
    var body: some View {
        VStack {
            Text("Detail Screen")
        }
        .navigationTitle("transaction.detail.title".localized)
        .accessibilityIdentifier("transaction_detail_screen")
        .navigationBarTitleDisplayMode(.inline)
    }
}
