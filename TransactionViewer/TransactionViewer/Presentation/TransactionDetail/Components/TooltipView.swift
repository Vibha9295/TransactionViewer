//
//  TooltipView.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import SwiftUI

struct TooltipView: View {
    @Binding var isExpanded: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("buddy-tip-icon")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.primary)
                .frame(width: 28)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 6) {
                collapseButton
                if isExpanded {
                    expandedContent
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 2)
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(.separator.opacity(0.5), lineWidth: 0.5)
        }
    }

    // MARK: - Subviews

    /// Single button that both expands and collapses the tooltip,
    /// replacing the previous split-logic approach.
    private var collapseButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                isExpanded.toggle()
            }
        } label: {
            Text(
                "\("tooltip.primary".localized) \(Text(isExpanded ? "" : "tooltip.show_more".localized).foregroundStyle(.blue).fontWeight(.bold))"
            )
            .font(.subheadline)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("tooltip_primary_text")
        .accessibilityLabel(
            isExpanded
                ? "tooltip.primary".localized
                : "\("tooltip.primary".localized) \("tooltip.show_more".localized)"
        )
    }

    private var expandedContent: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                isExpanded = false
            }
        } label: {
            Text(
                "\("tooltip.expanded".localized) \(Text("tooltip.show_less".localized).foregroundStyle(.blue).fontWeight(.bold))"
            )
            .font(.subheadline)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .accessibilityIdentifier("tooltip_expanded_text")
        .accessibilityLabel("\("tooltip.expanded".localized) \("tooltip.show_less".localized)")
    }
}
