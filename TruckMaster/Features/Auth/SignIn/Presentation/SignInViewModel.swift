//
//  SignInViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class SignInViewModel: ObservableObject {

    @Published var state = SignInState()

    private let loginUseCase: SignInUseCase
    private let router:       AppRouter

    init(loginUseCase: SignInUseCase, router: AppRouter) {
        self.loginUseCase = loginUseCase
        self.router       = router
    }

    func onAppear() { }

    var emailBinding: Binding<String> {
        Binding(
            get: { self.state.email },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.email = newValue
            }
        )
    }

    var passwordBinding: Binding<String> {
        Binding(
            get: { self.state.password },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.password = newValue
            }
        )
    }

    func loginTapped() {
        guard validate() else { return }
        UserPreferences.shared.hasSeenOnboarding = true
        Task { await login() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func googleTapped() { }

    func appleTapped() { }

    func signUpTapped() {
        router.navigate(to: .signUp)
    }

    func forgotPasswordTapped() {
        router.navigate(to: .forgotPassword)
    }

    private func validate() -> Bool {
        if state.email.isEmpty {
            triggerError("Email is required")
            return false
        }
        if state.password.isEmpty {
            triggerError("Password is required")
            return false
        }
        return true
    }

    private func login() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = LoginRequestModel(
            email:       state.email,
            password:    state.password,
            deviceId:    UIDevice.current.identifierForVendor?.uuidString ?? "",
            deviceToken: "firebase_token",
            deviceType:  "iOS"
        )

        do {
            let user = try await loginUseCase.execute(request: request)
            state.email = ""
            state.password = ""
                self.router.navigate(to: .home)
        }
        catch {
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
