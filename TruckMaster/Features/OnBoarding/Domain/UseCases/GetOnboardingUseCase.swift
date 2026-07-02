//
//  GetOnboardingUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

final class GetOnboardingUseCase {

    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    func execute() -> OnboardingItem {
        repository.getOnboardingData()
    }
}
