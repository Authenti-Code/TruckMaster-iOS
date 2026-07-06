//
//  ChangePasswordViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class ChangePasswordViewModel: ObservableObject {
    
    @Published var state = ChangePasswordState()

    private let changePasswordUseCase: ChangePasswordUseCase
    private let router: AppRouter

    init(changePasswordUseCase: ChangePasswordUseCase, router: AppRouter) {
        self.changePasswordUseCase = changePasswordUseCase
        self.router = router
    }

    func backTapped() {
        router.navigateBack()
    }

    func updateTapped() {
        guard validate() else { return }
        Task { await updatePassword() }
    }

    private func validate() -> Bool {
        if state.oldPassword.isEmpty {
            triggerError("Old password is required")
            return false
        }
        if state.newPassword.isEmpty {
            triggerError("New password is required")
            return false
        }
        if state.confirmPassword.isEmpty {
            triggerError("Confirm password is required")
            return false
        }
        if state.newPassword.count < 8 {
            triggerError("New password must be at least 8 characters")
            return false
        }
        if state.newPassword != state.confirmPassword {
            triggerError("Passwords do not match")
            return false
        }
        return true
    }

    private func updatePassword() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = ChangePasswordRequest(
            oldPassword: state.oldPassword,
            newPassword: state.newPassword
        )

        do {
            _ = try await changePasswordUseCase.execute(request: request)
            triggerSuccess("Password updated successfully")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router.navigateBack()
            }
        } catch {
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
}
