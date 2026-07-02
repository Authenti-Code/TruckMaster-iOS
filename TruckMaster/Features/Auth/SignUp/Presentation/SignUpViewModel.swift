//
//  SignUpViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class SignUpViewModel: ObservableObject {

    @Published var state = SignUpState()

    private let registerUseCase: SignUpUseCase
    private let router:          AppRouter

    init(registerUseCase: SignUpUseCase, router: AppRouter) {
        self.registerUseCase = registerUseCase
        self.router          = router
    }

    func onAppear() { }

    func registerTapped() {
        guard validate() else { return }
        Task { await register() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func googleTapped() { }

    func appleTapped() { }

    func signInTapped() {
        router.navigate(to: .signIn)
    }

    private func validate() -> Bool {
        if state.name.isEmpty {
            triggerError("Name is required")
            return false
        }
        if state.email.isEmpty {
            triggerError("Email is required")
            return false
        }
        if state.phone.isEmpty {
            triggerError("Contact is required")
            return false
        }
        if state.password.isEmpty {
            triggerError("Pasword is required")
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
        if !state.isAgreed {
            triggerError("Terms condition must be accepted")
            return false
        }
        return true
    }

    private func register() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = RegisterRequestModel(
            name:        state.name,
            email:       state.email,
            phoneNumber: state.phone,
            password:    state.password,
            confirmPassword:    state.confirmPassword,
            isAgreed:   "\(state.isAgreed)",
            deviceId:    UIDevice.current.identifierForVendor?.uuidString ?? "",
            deviceToken: "firebase_token",
            deviceType:  "iOS"
        )

        do {
            let user = try await registerUseCase.execute(request: request)
            UserPreferences.shared.saveUser(user)
            router.navigate(to: .home)
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
