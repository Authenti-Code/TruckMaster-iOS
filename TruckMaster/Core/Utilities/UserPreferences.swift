//
//  UserPreference.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

//
//  UserPreferences.swift
//  TruckMaster
//

import Foundation

final class UserPreferences {

    static let shared  = UserPreferences()
    private let defaults = UserDefaults.standard

    private enum Keys {
        static let user  = "saved_user"
        static let token = "saved_token"
        static let hasSeenOnboarding = "has_seen_onboarding"
    }

    func saveUser(_ user: UserModel) {
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: Keys.user)
        }
        defaults.set(user.token, forKey: Keys.token)
    }

    func getUser() -> UserModel? {
        guard let data = defaults.data(forKey: Keys.user),
              let user = try? JSONDecoder().decode(UserModel.self, from: data)
        else { return nil }
        return user
    }

    func getToken() -> String? {
        defaults.string(forKey: Keys.token)
    }

    func clearUser() {
        defaults.removeObject(forKey: Keys.user)
        defaults.removeObject(forKey: Keys.token)
    }

    var isLoggedIn: Bool {
        getToken() != nil
    }
    
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasSeenOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasSeenOnboarding) }
    }
}
