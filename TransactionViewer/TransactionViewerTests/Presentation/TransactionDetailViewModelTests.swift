//
//  TransactionDetailViewModelTests.swift
//  TransactionViewer
//
//  Created by Vibha on 2026-06-26.
//

import Testing
@testable import TransactionViewer

@Suite("TransactionDetailViewModel Tests")
struct TransactionDetailViewModelTests {
    
    @MainActor
    @Test("Credit transaction uses the success icon")
    func creditUsesSuccessIcon() {
        let vm = TransactionDetailViewModel(transaction: .makeMock(type: .credit))
        #expect(vm.statusIcon == "success-icon")
    }

    @MainActor
    @Test("Debit transaction uses the red checkmark icon")
    func debitUsesRedCheckmarkIcon() {
        let vm = TransactionDetailViewModel(transaction: .makeMock(type: .debit))
        #expect(vm.statusIcon == "red_checkmark_icon")
    }

    @MainActor
    @Test("Tooltip starts collapsed")
    func tooltipStartsCollapsed() {
        let vm = TransactionDetailViewModel(transaction: .makeMock())
        #expect(vm.isTooltipExpanded == false)
    }

    @MainActor
    @Test("toggleTooltip expands then collapses on successive calls")
    func tooltipTogglesCycle() {
        let vm = TransactionDetailViewModel(transaction: .makeMock())

        vm.toggleTooltip()
        #expect(vm.isTooltipExpanded == true)

        vm.toggleTooltip()
        #expect(vm.isTooltipExpanded == false)
    }

    @MainActor
    @Test("ViewModel exposes the transaction it was initialised with")
    func viewModelStoresTransaction() {
        let vm = TransactionDetailViewModel(transaction: .makeMock(merchantName: "Test Store"))
        #expect(vm.transaction.displayMerchantName == "Test Store")
    }
}
