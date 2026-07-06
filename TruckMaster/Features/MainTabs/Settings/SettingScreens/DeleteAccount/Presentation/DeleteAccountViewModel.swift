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

    private let deleteAccountUseCase: DeleteAccountUseCase
    private let router: AppRouter

    init(deleteAccountUseCase: DeleteAccountUseCase, router: AppRouter) {
        self.deleteAccountUseCase = deleteAccountUseCase
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

    func deleteAccountTapped() async{
        state.showPasswordSheet = false
        state.isLoading = true
        defer { state.isLoading = false }
        
        let request = DeleteAccountRequestModel(
            password:   state.password,
            reason: "\(String(describing: state.selectedReason?.title))"
        )
        do {
            let message = try await deleteAccountUseCase.execute(request: request)
            triggerSuccess(message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UserPreferences.shared.clearUser()
                self.router.navigateToRoot()
                self.router.navigate(to: .signIn)
            }
            
        }
        catch{
            triggerError(error.localizedDescription)
        }
    
    }
    
    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }

    private func triggerSuccess(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .success
        state.showSnackbar    = true
    }

    func backTapped() {
        router.navigateBack()
    }
}
