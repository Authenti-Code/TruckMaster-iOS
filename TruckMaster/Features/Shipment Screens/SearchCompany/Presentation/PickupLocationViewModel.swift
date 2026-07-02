//
//  PickupLocationViewModel.swift
//  TruckMaster

import Foundation
import CoreLocation
import UIKit
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

    func companyTapped(_ company: CompanyModel) {
        router.navigate(to: .orderDetails)
    }
    
    private func searchForCompany() async {
        state.isSearching = true
        state.visibleCount = 0

        do {
            let results = try await repository.fetchCompany()
            state.isSearching = false
            state.companies = results

            for i in 1...max(1, results.count) {
                try? await Task.sleep(for: .milliseconds(1200))
                state.visibleCount = i
            }

        } catch {
          
        }
    }
}
