//
//  SettingsViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation
internal import Combine
import UIKit

@available(iOS 16.0, *)
@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var state = SettingsState()

    private let settingUseCase: GetUserProfileUseCase
    private let router: AppRouter

    init(
        getUserProfileUseCase: GetUserProfileUseCase,
        router: AppRouter
    ) {
        self.settingUseCase = getUserProfileUseCase
        self.router                = router
    }

    // MARK: - Lifecycle
    func onAppear() {
        if let cached = UserPreferences.shared.getUser() {
            state.user = cached
        } else {
            Task { await loadProfile() }
        }
    }
    

    // MARK: - Actions
    func editTapped() {
         router.navigate(to: .editProfile)
    }

    func notificationTapped() {
         router.navigate(to: .notifications)
    }

    func settingsItemTapped(_ item: SettingsItemModel) {
        switch item.route {
        case .savedAddress:       router.navigate(to: .savedAddress)
        case .accountSettings:    router.navigate(to: .accountSettings)
        case .helpAndSupport:    router.navigate(to: .helpAndSupport)
        case .faqs:              router.navigate(to: .faqs)
        case .termsAndConditions:     router.navigate(to: .termsAndConditions(isPolicy: false))
        case .privacyPolicy:     router.navigate(to: .termsAndConditions(isPolicy: true))
        }
    }

    func logoutTapped() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = LogoutRequestModel(
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? ""
        )
        do {
//            let message = try await settingUseCase.logoutExecute(request: request)

            UserPreferences.shared.clearUser()
            router.navigateToRoot()
            router.navigate(to: .signIn)

        }
//        catch {
//            triggerError(error.localizedDescription)
//        }
    }
    

    // MARK: - Private
    private func loadProfile() async {
        if state.user == nil {
            state.isLoading = true
        }
        defer { state.isLoading = false }

        do {
            state.profile = try await settingUseCase.execute()
            state.user = UserPreferences.shared.getUser()
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
