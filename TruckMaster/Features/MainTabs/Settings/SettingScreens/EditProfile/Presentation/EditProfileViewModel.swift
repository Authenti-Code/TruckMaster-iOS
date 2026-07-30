//
//  EditProfileViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//


internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class EditProfileViewModel: ObservableObject {

    @Published var state = EditProfileState()

    @Published var nameError: String?
    @Published var contactError: String?

    private static let allowedDigits = Set("0123456789")

    private let editProfileUseCase: EditProfileUseCase
    private let router: AppRouter

    init(
        editProfileUseCase: EditProfileUseCase,
        router: AppRouter
    ) {
        self.editProfileUseCase = editProfileUseCase
        self.router               = router
    }

    func onAppear() {
        loadUserInfo()
    }

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

    var contactBinding: Binding<String> {
        Binding(
            get: { self.state.contact },
            set: { self.handleContactChange($0) }
        )
    }

    private func handleNameChange(_ newValue: String) {
        guard !newValue.hasPrefix(" ") else { return }
        state.name = newValue
        validateNameRealTime()
    }

    private func handleContactChange(_ newValue: String) {
        state.contact = newValue.filter { Self.allowedDigits.contains($0) }
        if !state.contact.isEmpty {
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

    func backTapped() {
        router.navigateBack()
    }

    func updateTapped() {
        guard validate() else { return }
        Task { await updateProfile() }
    }

    private func validate() -> Bool {

        nameError = nil
        contactError = nil

        let trimmedName  = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = state.email.trimmingCharacters(in: .whitespacesAndNewlines)

        state.name  = trimmedName
        state.email = trimmedEmail

        // Name
        if trimmedName.isEmpty {
            nameError = "Name is required"
            triggerError("Name is required")
            return false
        }

        if trimmedName.count < 3 {
            nameError = "Name must be at least 3 characters"
            triggerError("Name must be at least 3 characters")
            return false
        }

        // Email
        if trimmedEmail.isEmpty {
            triggerError("Email is required")
            return false
        }

        if !isValidEmail(trimmedEmail) {
            triggerError("Please enter a valid email address")
            return false
        }

        // Contact
        if state.contact.isEmpty {
            contactError = "Contact is required"
            triggerError("Contact is required")
            return false
        }

        if state.contact.count != 10 {
            contactError = "Contact must be exactly 10 digits"
            triggerError("Contact must be exactly 10 digits")
            return false
        }

        return true
    }

    func changeImageTapped() {
        // image picker logic
    }

    // MARK: - Private
    private func loadUserInfo() {
        let user         = UserPreferences.shared.getUser()
        state.name       = user?.name      ?? ""
        state.email      = user?.email     ?? ""
        state.contact    = user?.phoneNumber   ?? ""
        state.profileImg = user?.profileImage ?? ""
    }

    private func updateProfile() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = EditProfileRequestModel(
            name: state.name,
            email: state.email,
            contact: state.contact,
            profileImg: ""
        )

        do {
            let message = try await editProfileUseCase.execute(
                request: request,
                image: state.selectedImage
            )

            // Update local user
            if let existingUser = UserPreferences.shared.getUser() {

                let updatedUser = UserModel(
                    id: existingUser.id,
                    token: existingUser.token,
                    name: state.name,
                    email: state.email,
                    phoneNumber: state.contact,
                    profileImage: existingUser.profileImage
                )

                UserPreferences.shared.saveUser(updatedUser)
            }

            triggerSuccess(message)

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
