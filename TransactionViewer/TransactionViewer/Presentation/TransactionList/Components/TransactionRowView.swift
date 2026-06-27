//
//  TransactionRowView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            transactionIcon
            transactionLabels
            Spacer(minLength: 8)
            amountAndDate
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    private var transactionIcon: some View {
        ZStack {
            Circle()
                .fill(iconBackground)
                .frame(width: 44, height: 44)

            Image(systemName: iconName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(iconForeground)
        }
    }

    private var transactionLabels: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(transaction.displayMerchantName)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            if let desc = transaction.description, !desc.isEmpty {
                Text(desc)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var amountAndDate: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(amountDisplay)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(amountColor)

            Text(transaction.displayPostedDate)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var isCredit: Bool { transaction.type.isCredit }

    private var iconName: String {
        isCredit ? "arrow.down.circle.fill" : "arrow.up.circle.fill"
    }

    private var iconBackground: Color {
        isCredit ? Color.transactionGreen.opacity(0.12) : Color(.systemGray6)
    }

    private var iconForeground: Color {
        isCredit ? .transactionGreen : .secondary
    }

    private var amountColor: Color {
        isCredit ? .transactionGreen : .primary
    }

    private var amountDisplay: String {
        "\(isCredit ? "+" : "-")\(transaction.amount.formatted)"
    }
}
