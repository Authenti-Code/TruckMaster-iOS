//
//  PickupLocationViewModel.swift
//  TruckMaster

internal import Foundation
internal import CoreLocation
internal import UIKit
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class PickupLocationViewModel: ObservableObject {

    @Published var state: PickupLocationState
    private let router: AppRouter
    private let repository: SearchCompanyRepository

    init(
        coordinate: CLLocationCoordinate2D,
        profileImage: UIImage?,
        repository: SearchCompanyRepository,
        router: AppRouter
    ) {
        self.state = PickupLocationState(coordinate: coordinate, profileImage: profileImage)
        self.repository = repository
        self.router = router
    }

    func onAppear() {
        Task { await searchForCompany() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func companyTapped(_ offer: ActiveOrderOffer) {
        router.navigate(to: .orderDetails)
    }

    private func searchForCompany() async {
        state.isSearching = true
        state.visibleCount = 0

        do {
            let activeOrder = try await repository.fetchActiveOrder()
            state.isSearching = false
            state.offers = activeOrder.offers

            for i in 1...max(1, activeOrder.offers.count) {
                try? await Task.sleep(for: .milliseconds(1000))
                state.visibleCount = i
            }

        } catch {

        }
    }
}
