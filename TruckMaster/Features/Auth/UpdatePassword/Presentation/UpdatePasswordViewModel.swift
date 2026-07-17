//
//  VerifyCodeViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class UpdatePasswordViewModel: ObservableObject {

    @Published var state = UpdatePasswordState()

    private let updatePasswordUseCase: UpdatePasswordUseCase
    private let router: AppRouter

    init(updatePasswordUseCase: UpdatePasswordUseCase, router: AppRouter) {
        self.updatePasswordUseCase = updatePasswordUseCase
        self.router            = router
    }

    func onAppear() { }

    var passwordBinding: Binding<String> {
        Binding(
            get: { self.state.password },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.password = newValue
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

    func updatePasswordTapped() {
        guard validate() else { return }
        Task { await updatePassword() }
    }
    
    private func validate() -> Bool {
        
        if state.password.isEmpty {
            triggerError("Password is required")
            return false
        }
        if state.password.count < 8 {
            triggerError("Password must be at least 8 characters")
            return false
        }
        if state.confirmPassword.isEmpty {
            triggerError("Confirm password is required")
            return false
        }
        if state.password != state.confirmPassword {
            triggerError("Password and confirm password doesn't match")
            return false
        }
        return true
    }

    private func updatePassword() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = UpdatePasswordRequestModel(
            resetToken: state.resetToken,
            password:   state.password,
            confirmPassword:  state.confirmPassword
        )

        do {
            let message = try await updatePasswordUseCase.execute(request: request)
            triggerSuccess(message)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            router.navigateToRoot()
            router.navigate(to: .signIn)
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
