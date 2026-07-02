//
//  OnboardingViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI
internal import Combine


@available(iOS 16.0, *)
@MainActor
final class OnboardingViewModel: ObservableObject {

    @Published var state = OnboardingState()

    private let getOnboardingUseCase: GetOnboardingUseCase
    private let router: AppRouter

    init(getOnboardingUseCase: GetOnboardingUseCase, router: AppRouter) {
        self.getOnboardingUseCase = getOnboardingUseCase
        self.router = router
    }

    func onAppear() {
        state.onboardingItem = getOnboardingUseCase.execute()
    }

    func nextTapped() {
        router.navigate(to: .selectLanguage)
    }
}
