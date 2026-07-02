//
//  SplashRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

import Foundation

final class SplashRepositoryImpl: SplashRepository {

    func isLoggedIn() -> Bool {
        UserPreferences.shared.isLoggedIn
    }

    func hasSeenOnboarding() -> Bool {
        UserPreferences.shared.hasSeenOnboarding
    }

}
