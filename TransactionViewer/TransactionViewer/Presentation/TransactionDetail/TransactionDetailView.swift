//
//  TransactionDetailView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @State private var viewModel: TransactionDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: TransactionDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            Color(uiColor: .systemBackground)
                .frame(height: 0)
                .ignoresSafeArea(edges: .top)

            Divider()
                .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)

            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea(edges: .bottom)

                VStack(spacing: 0) {
                    Spacer().frame(height: 24)
                    detailCard
                    Spacer().frame(height: 20)
                }
            }
            .accessibilityIdentifier("transaction_detail_screen")
        }
        .navigationTitle("transaction.detail.title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: Card

    private var detailCard: some View {
        VStack(spacing: 0) {
            VStack(spacing: 14) {
                Image(viewModel.statusIcon)
                    .resizable()
                    .frame(width: 44, height: 44)

                Text(viewModel.transaction.type.displayTitle)
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 32)
            .padding(.bottom, 28)

            DetailRowView(
                label: "detail.from".localized,
                value: viewModel.transaction.displayFromAccount,
                suffix: viewModel.transaction.displayCardSuffix.isEmpty ? nil : viewModel.transaction.displayCardSuffix
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider().padding(.horizontal, 20)

            DetailRowView(
                label: "detail.amount".localized,
                value: viewModel.transaction.amount.formatted,
                valueFont: .title3
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            TooltipView(isExpanded: $viewModel.isTooltipExpanded)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            Spacer(minLength: 20)

            closeButton
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 12)
        .accessibilityElement(children: .contain)
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Text("detail.close".localized)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.destructiveRed)
                )
        }
        .accessibilityIdentifier("detail_close_button")
    }
}
