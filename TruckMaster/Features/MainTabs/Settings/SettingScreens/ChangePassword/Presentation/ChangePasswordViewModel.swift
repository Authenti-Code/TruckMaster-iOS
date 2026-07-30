//
//  ChangePasswordViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


import Foundation
internal import SwiftUI
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

    var oldPasswordBinding: Binding<String> {
        Binding(
            get: { self.state.oldPassword },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.oldPassword = newValue
            }
        )
    }

    var newPasswordBinding: Binding<String> {
        Binding(
            get: { self.state.newPassword },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.newPassword = newValue
            }
        )
    }

    var confirmPasswordBinding: Binding<String> {
        Binding(
            get: { self.state.confirmPassword },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.confirmPassword = newValue
            }
        )
    }

    func backTapped() {
        router.navigateBack()
    }

    func updateTapped() {
        guard validate() else { return }
        Task { await updatePassword() }
    }

    private func validate() -> Bool {
        if state.oldPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            triggerError("Old password is required")
            return false
        }

        if state.newPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            triggerError("New password is required")
            return false
        }

        if state.newPassword.count < 8 {
            triggerError("New password must be at least 8 characters")
            return false
        }

        if state.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            triggerError("Confirm password is required")
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
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            router.navigateBack()
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
