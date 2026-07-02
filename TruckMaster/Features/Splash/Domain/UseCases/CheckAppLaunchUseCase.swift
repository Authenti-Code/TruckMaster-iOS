//
//  CheckAppLaunchUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

final class CheckAppLaunchUseCase {

    private let repository: SplashRepository

    init(repository: SplashRepository) {
        self.repository = repository
    }

    func execute() -> Route {
           if repository.isLoggedIn() {
               return .home
           } else if repository.hasSeenOnboarding() {
               return .signIn
           } else {
               return .onboarding
           }
       }
}
