//
//  DetailRowView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

// label + value row for the detail card — suffix handles the card number hint
struct DetailRowView: View {

    let label: String
    let value: String
    var suffix: String?
    var valueFont: Font = .body   // amount row needs a larger font than the rest

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                Text(value)
                    .font(valueFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                if let suffix {
                    Text(suffix)
                        .font(valueFont)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 0) {
        DetailRowView(label: "From", value: "Chequing", suffix: "(1234)")
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        Divider().padding(.horizontal, 20)
        DetailRowView(label: "Amount", value: "$112.38", valueFont: .title3)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
    .background(Color(uiColor: .systemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}
