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
final class VerifyCodeViewModel: ObservableObject {

    @Published var state = VerifyCodeState()

    private let verifyCodeUseCase: VerifyCodeUseCase
    private let router: AppRouter

    init(verifyCodeUseCase: VerifyCodeUseCase, router: AppRouter) {
        self.verifyCodeUseCase = verifyCodeUseCase
        self.router            = router
    }

    func onAppear() { }

    func backTapped() {
        router.navigateBack()
    }

    func verifyOtpTapped() {
        guard validate() else { return }
        Task { await verifyOTP() }
    }

    func resendCodeTapped() {
        Task { await resendCode() }
    }

    private func resendCode() async {
        state.isLoading = true
        defer { state.isLoading = false }
        let request = ResendCodeRequestModel(resetToken: state.resetToken)

        do {
            let message = try await verifyCodeUseCase.executeResendCode(request: request)
            triggerSuccess(message)
            
           
        } catch {
            triggerError(error.localizedDescription)
        }
    }
    
    
    private func validate() -> Bool {
        
        if state.otp.count == 0 {
            triggerError("OTP is required")
            return false
        }
        
        if state.otp.count < 4 {
            triggerError("Please enter complete OTP")
            return false
        }
        return true
    }

    private func verifyOTP() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = VerifyCodeRequestModel(
            resetToken: state.resetToken,
            otp:        state.otp
        )

        do {
            let message = try await verifyCodeUseCase.execute(request: request)
            triggerSuccess(message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router.navigate(to: .updatePassword(resetToken: self.state.resetToken))
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
