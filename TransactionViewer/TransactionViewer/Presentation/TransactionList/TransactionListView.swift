//
//  TransactionListView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

struct TransactionListView: View {
    @State private var viewModel: TransactionListViewModel

    init(viewModel: TransactionListViewModel = TransactionListViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    loadingView
                case .loaded(let transactions):
                    transactionList(transactions)
                case .failed(let message):
                    errorView(message: message)
                }
            }
            .navigationTitle("transactions.title".localized)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Transaction.self) { transaction in
                TransactionDetailView(
                    viewModel: TransactionDetailViewModel(transaction: transaction)
                )
            }
        }
        .task {
            await viewModel.loadTransactions()
        }
    }

    // MARK: Sub-views

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .accessibilityIdentifier("transactions_loading_indicator")
            Text("transactions.loading".localized)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func transactionList(_ transactions: [Transaction]) -> some View {
        Group {
            if transactions.isEmpty {
                emptyView
            } else {
                List(transactions) { transaction in
                    NavigationLink(value: transaction) {
                        TransactionRowView(transaction: transaction)
                    }
                    .listRowSeparatorTint(Color(uiColor: .separator))
                }
                .listStyle(.insetGrouped)
                .accessibilityIdentifier("transactions_list")
                .refreshable {
                    await viewModel.loadTransactions()
                }
            }
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            "transactions.empty.title".localized,
            systemImage: "creditcard.slash",
            description: Text("transactions.empty.description".localized)
        )
    }

    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label("transactions.error.title".localized, systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("transactions.error.retry".localized) {
                Task { await viewModel.loadTransactions() }
            }
            .buttonStyle(.bordered)
        }
    }
}
