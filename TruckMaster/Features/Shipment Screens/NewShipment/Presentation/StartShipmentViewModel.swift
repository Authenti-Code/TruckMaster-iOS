//
//  StartShipmentViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class StartShipmentViewModel: ObservableObject {

    @Published var state = StartShipmentState()
    private let draft: ShipmentDraft
    
    private let getUserProfileUseCase: GetUserProfileUseCase
    private let getSavedAddressesUseCase: GetSavedAddressesUseCase
    private let router: AppRouter

    init(
        getUserProfileUseCase: GetUserProfileUseCase,
        getSavedAddressesUseCase: GetSavedAddressesUseCase,
        draft: ShipmentDraft,
        router: AppRouter
    ) {
        self.getUserProfileUseCase = getUserProfileUseCase
        self.getSavedAddressesUseCase = getSavedAddressesUseCase
        self.draft = draft
        self.router = router
    }

    func onAppear() {
        if let updated = router.pendingLocationUpdate {
            state.dropAddress = updated.address
            state.dropSubAddress = updated.subAddress
            state.dropLatitude = updated.latitude
            state.dropLongitude = updated.longitude
            router.pendingLocationUpdate = nil
        }
        if let cached = UserPreferences.shared.getUser() {
            state.user = cached
        }
        Task { await loadInitialData() }
    }

    func backTapped() {
        router.navigateToRoot()
        router.navigate(to: .home)
    }

    func pickupTapped() {
        print("Address payload: \(draft)")
        router.navigate(to: .addAddress(isUpdatingLocation: true, comingFrom: .shipmentPickup))
    }

    func dropLocationTapped() {
        router.navigate(to: .addAddress(isUpdatingLocation: true, comingFrom: .shipmentDrop))
    }

    func savedAddressTapped(_ address: SavedAddressModel) {
        state.dropAddress = address.address
        state.dropSubAddress = ""
        print("Address payload: \(draft)")
        
    }

    private func loadInitialData() async {
        state.isLoading = true
        defer { state.isLoading = false }

        async let profile = getUserProfileUseCase.execute()
        async let addresses = getSavedAddressesUseCase.execute()

        do {
            let (userProfile, savedAddresses) = try await (profile, addresses)
            state.pickupName = state.user?.name ?? ""
            state.pickupPhone = state.user?.phoneNumber ?? ""
            state.pickupAddress = draft.pickup?.address ?? ""
            state.savedAddresses = savedAddresses
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
