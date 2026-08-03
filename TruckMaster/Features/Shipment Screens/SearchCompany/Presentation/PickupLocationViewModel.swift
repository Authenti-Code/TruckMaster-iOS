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
    private let offerSocketRepository: OfferSocketRepositoryProtocol

    private var offerSocketTask: Task<Void, Never>?
    private var expiryTasks: [Int: Task<Void, Never>] = [:]

    init(
        coordinate: CLLocationCoordinate2D,
        profileImage: UIImage?,
        repository: SearchCompanyRepository,
        router: AppRouter,
        offerSocketRepository: OfferSocketRepositoryProtocol? = nil
    ) {
        self.state = PickupLocationState(coordinate: coordinate, profileImage: profileImage)
        self.repository = repository
        self.router = router
        self.offerSocketRepository = offerSocketRepository ?? OfferSocketRepository()
    }

    func onAppear() {
        Task { await searchForCompany() }
        observeOffers()
    }

    func backTapped() {
        router.navigateBack()
    }

    func companyTapped(_ offer: ActiveOrderOffer) {
        removeOffer(offer)
        state.companyId = offer.company.id
        router.navigate(to: .orderDetails(orderId: state.orderId ?? "0", companyId: state.companyId ?? 0))
    }

    func rejectTapped(_ offer: ActiveOrderOffer) {
        removeOffer(offer)
    }

    private func searchForCompany() async {
        state.isSearching = true
        state.visibleCount = 0

        do {
            let activeOrder = try await repository.fetchActiveOrder()
            state.isSearching = false
            state.offers = activeOrder.offers
            state.orderId = activeOrder.order?.id.toString

            for i in 1...max(1, activeOrder.offers.count) {
                try? await Task.sleep(for: .milliseconds(1000))
                state.visibleCount = i
            }

        } catch {

        }
    }

    // MARK: - Socket
    private func observeOffers() {
        offerSocketTask?.cancel()

        offerSocketTask = Task {
            guard let userId = UserPreferences.shared.getToken() else { return }

            offerSocketRepository.startListening(resourceId: userId)

            for await offer in offerSocketRepository.shipmentStream() {
                guard !Task.isCancelled else { break }

                guard !state.offers.contains(where: { $0.company.id == offer.company.id }) else {
                    continue
                }

                state.offers.insert(offer, at: 0)
                scheduleExpiry(for: offer)
            }
        }
    }

    // MARK: - Expiry
    private func scheduleExpiry(for offer: ActiveOrderOffer) {
        let id = offer.company.id
        guard let expiresAtString = offer.expiresAt, !expiresAtString.isEmpty else { return }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let expiryDate = formatter.date(from: expiresAtString) else { return }

        expiryTasks[id]?.cancel()

        expiryTasks[id] = Task {
            let interval = expiryDate.timeIntervalSinceNow

            if interval > 0 {
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }

            guard !Task.isCancelled else { return }
            state.offers.removeAll { $0.company.id == id }
            expiryTasks[id] = nil
        }
    }

    private func removeOffer(_ offer: ActiveOrderOffer) {
        state.offers.removeAll { $0.company.id == offer.company.id }
        expiryTasks[offer.company.id]?.cancel()
        expiryTasks[offer.company.id] = nil
    }
}
