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


    func backTapped() {
        router.navigateBack()
    }

    func updateTapped() {
        guard validate() else { return }
        Task { await updateProfile() }
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
        if state.contact.isEmpty {
            triggerError("Contact is required")
            return false
        }
        return true
    }

    func changeImageTapped() {
        // image picker logic
    }

    // MARK: - Private
    private func loadUserInfo() {
        let user        = UserPreferences.shared.getUser()
        state.name      = user?.name      ?? ""
        state.email     = user?.email     ?? ""
        state.contact   = user?.phoneNumber   ?? ""
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
