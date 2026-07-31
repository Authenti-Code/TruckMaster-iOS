//
//  ShipmentCompletedViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 19/06/26.
//

internal import Foundation

@available(iOS 16.0, *)
@MainActor
final class ShipmentCompletedViewModel {

    

    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }

    func shareExperienceTapped() {
        // hook up share sheet / feedback flow here
    }


        func backToHomeTapped() {
            router.navigateToRoot()
            router.navigate(to: .home)
        }
}
