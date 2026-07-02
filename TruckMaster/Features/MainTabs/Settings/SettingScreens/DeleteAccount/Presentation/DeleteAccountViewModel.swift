//
//  DeleteAccountViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import Combine
internal import SwiftUI

@available(iOS 16.0, *)
@MainActor
final class DeleteAccountViewModel: ObservableObject {

    @Published var state = DeleteAccountState()

    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router

        state.reasons = [
            DeleteReason(title: "delete_account_reason_1"),
            DeleteReason(title: "delete_account_reason_2"),
            DeleteReason(title: "delete_account_reason_3"),
            DeleteReason(title: "delete_account_reason_4"),
            DeleteReason(title: "delete_account_reason_5")
        ]
    }

    func selectReason(_ reason: DeleteReason) {
        state.selectedReason = reason
    }

    func proceedTapped() {
        state.showPasswordSheet = true
    }

    func deleteAccountTapped() {
        // API call
    }

    func backTapped() {
        router.navigateBack()
    }
}
