//
//  AccountSettingsViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


import Foundation
@available(iOS 16.0, *)
@MainActor
final class AccountSettingsViewModel {
  

    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }

    func backTapped() {
        router.navigateBack()
    }

    func notificationsTapped() {
        router.navigate(to: .notifications)
    }

    func changePasswordTapped() {
        router.navigate(to: .changePassword)
    }

    func deleteAccountTapped() {
        router.navigate(to: .deleteAccount)
    }


}
