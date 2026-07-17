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

    @Published var nameError: String?
    @Published var contactError: String?

    private static let allowedDigits = Set("0123456789")

    private let registerUseCase: SignUpUseCase
    private let router:          AppRouter

    init(registerUseCase: SignUpUseCase, router: AppRouter) {
        self.registerUseCase = registerUseCase
        self.router          = router
    }

    func onAppear() { }

    var nameBinding: Binding<String> {
        Binding(
            get: { self.state.name },
            set: { self.handleNameChange($0) }
        )
    }

    var emailBinding: Binding<String> {
        Binding(
            get: { self.state.email },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.email = newValue
            }
        )
    }

    var phoneBinding: Binding<String> {
        Binding(
            get: { self.state.phone },
            set: { self.handlePhoneChange($0) }
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

    var confirmPasswordBinding: Binding<String> {
        Binding(
            get: { self.state.confirmPassword },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.confirmPassword = newValue
            }
        )
    }

    private func handleNameChange(_ newValue: String) {
        guard !newValue.hasPrefix(" ") else { return }
        state.name = newValue
        validateNameRealTime()
    }

    private func handlePhoneChange(_ newValue: String) {
        state.phone = newValue.filter { Self.allowedDigits.contains($0) }
        if !state.phone.isEmpty {
            contactError = nil
        }
    }

    private func validateNameRealTime() {
        let trimmed = state.name.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            nameError = nil
        } else if trimmed.count < 3 {
            nameError = "Name must be at least 3 characters"
        } else {
            nameError = nil
        }
    }

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
        let trimmedName = state.name.trimmingCharacters(in: .whitespaces)

        if trimmedName.isEmpty {
            nameError = nil
            triggerError("Name is required")
            return false
        }
        if trimmedName.count < 3 {
            nameError = "Name must be at least 3 characters"
            triggerError("Name must be at least 3 characters")
            return false
        }
        state.name = trimmedName

        if state.email.isEmpty {
            triggerError("Email is required")
            return false
        }
        if state.phone.isEmpty {
            contactError = "Contact is required"
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
