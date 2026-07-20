//
//  ForgotPasswordViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class ForgotPasswordViewModel: ObservableObject {

    @Published var state = ForgotPasswordState()

    private let forgotPasswordUseCase: ForgotPasswordUseCase
    private let router: AppRouter

    init(forgotPasswordUseCase: ForgotPasswordUseCase, router: AppRouter) {
        self.forgotPasswordUseCase = forgotPasswordUseCase
        self.router                = router
    }

    func onAppear() { }

    var emailBinding: Binding<String> {
        Binding(
            get: { self.state.email },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                DispatchQueue.main.async {
                    self.state.email = newValue
                }
            }
        )
    }

    func backTapped() {
        router.navigateBack()
    }

    func sendOTPTapped() {
        guard validate() else { return }
        Task { await sendOTP() }
    }

    private func validate() -> Bool {
        if state.email.isEmpty {
            triggerError("Email is required")
            return false
        }
        return true
    }

    private func sendOTP() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = ForgotPasswordRequestModel(email: state.email)

        do {
            let (data, message) = try await forgotPasswordUseCase.execute(request: request)
            triggerSuccess(message)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            router.navigate(to: .verifyCode(resetToken: data.resetToken))
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
