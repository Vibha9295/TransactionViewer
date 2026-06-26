//
//  TransactionListView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

struct TransactionListView: View {
    @State private var viewModel = TransactionListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                case .loaded(let transactions):
                    Text("Loaded \(transactions.count) transactions")
                case .failed(let error):
                    Text("Error: \(error)")
                }
            }
            .navigationTitle("Transactions")
            .navigationDestination(for: Transaction.self) { transaction in
                TransactionDetailView(transaction: transaction)
            }
        }
        .task {
            await viewModel.loadTransactions()
        }
    }
}
