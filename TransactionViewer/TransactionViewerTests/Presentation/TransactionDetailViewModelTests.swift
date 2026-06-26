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
    @Test("Status icon is success-icon regardless of transaction type")
    func statusIconIsAlwaysSuccess() {
        let credit = TransactionDetailViewModel(transaction: .makeMock(type: .credit))
        let debit  = TransactionDetailViewModel(transaction: .makeMock(type: .debit))

        // hardcoded until the API adds a status field — both should return the same icon
        #expect(credit.statusIcon == "success-icon")
        #expect(debit.statusIcon  == "success-icon")
    }

    @MainActor
    @Test("Tooltip starts collapsed and toggles correctly")
    func tooltipToggle() {
        let vm = TransactionDetailViewModel(transaction: .makeMock())
        #expect(vm.isTooltipExpanded == false)

        vm.toggleTooltip()
        #expect(vm.isTooltipExpanded == true)

        vm.toggleTooltip()
        #expect(vm.isTooltipExpanded == false)
    }

    @MainActor
    @Test("ViewModel holds the same transaction it was initialised with")
    func viewModelStoresTransaction() {
        let transaction = Transaction.makeMock(merchantName: "Test Store")
        let vm = TransactionDetailViewModel(transaction: transaction)
        #expect(vm.transaction.displayMerchantName == "Test Store")
    }
}
