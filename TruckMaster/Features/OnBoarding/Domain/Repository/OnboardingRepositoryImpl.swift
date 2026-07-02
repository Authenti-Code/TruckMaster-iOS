//
//  OnboardingRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

final class OnboardingRepositoryImpl:
OnboardingRepository {

    func getOnboardingData() -> OnboardingItem {

        OnboardingItem(
            title: "BOOK, TRACK,",
            highlightedTitle: "DONE.",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed et rutrum purus, auctor feugiat enim.",
            imageName: "truck_onboarding"
        )
    }
}
