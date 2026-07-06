//
//  HomeViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//
internal import SwiftUI
internal import Combine

// MARK: - ViewModel
@available(iOS 16.0, *)
@MainActor
final class HomeViewModel: ObservableObject {
   
    @Published var state = HomeState()
    private let draft: ShipmentDraft
    private var locationTask: Task<Void, Never>?
    
    private let getShipmentsUseCase: GetShipmentsUseCase
    private let locationManager = LocationManager.shared
    private let router: AppRouter

    init(
        getShipmentsUseCase: GetShipmentsUseCase,
        draft: ShipmentDraft,
        router: AppRouter
    ) {
        self.getShipmentsUseCase = getShipmentsUseCase
        self.draft                = draft
        self.router              = router
    }

    // MARK: - Lifecycle
    func onAppear() {
        draft.reset()
        loadUserInfo()
        Task { await loadShipments(isRefresh: false) }
    }

    func onRefresh() async {
        await loadShipments(isRefresh: true)
    }

    // MARK: - Actions
    func notificationTapped() {
         router.navigate(to: .notifications)
//         router.navigate(to: .giveFeedback)
//        router.navigate(to: .mapTrack)
    }

    func startNewShipmentTapped() {
        router.startNewShipment()
        router.navigate(to: .startShipment)
    }

    func trackDeliveryTapped() {
         router.navigate(to: .enRoute)
//         router.navigate(to: .shipmentCompleted)
    }

    private func loadShipments(isRefresh: Bool) async {
        if isRefresh {
            state.isRefreshing = true
        } else {
            state.isLoading = true
        }
        defer {
            state.isLoading    = false
            state.isRefreshing = false
        }
        do {
            state.shipments = try await getShipmentsUseCase.execute()
            let profile = try await getShipmentsUseCase.executeGetProfile()
            state.profileData = profile
            syncProfileToLocal(profile)
            state.snackbarMessage = ""
        } catch {
            triggerError(error.localizedDescription)
        }
    }
    
    private func syncProfileToLocal(_ profile: ProfileResponse) {

        guard let profileData = profile.data else { return }

        let existingToken = UserPreferences.shared.getToken() ?? ""

        let updatedUser = UserModel(
            id: profileData.id ?? "",
            token: existingToken,
            name: profileData.name ?? "",
            email: profileData.email ?? "",
            phoneNumber: profileData.phoneNumber ?? "",
            profileImage: profileData.profileImage
        )

        UserPreferences.shared.saveUser(updatedUser)
    }


    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }

    private func triggerSuccess(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .success
        state.showSnackbar    = true
    }
    
    private func loadUserInfo() {
        let user       = UserPreferences.shared.getUser()
        state.userName = user?.name ?? ""
        
        locationManager.requestPermission()
        
        locationTask?.cancel()
        locationTask = Task {
            for await name in locationManager.$locationName.values {
                guard !Task.isCancelled else { break }
                if !name.isEmpty {
                    state.locationName = name
                    state.address = locationManager.currentAddress
                    
                    if let details = locationManager.currentAddressDetails {
                        state.latitude = details.latitude
                        state.longitude = details.longitude
                        
                        draft.pickup = AddressPayload(
                            address: details.address,
                            latitude: String(details.latitude),
                            longitude: String(details.longitude),
                            name: user?.name,
                            contact: user?.phoneNumber,
                            landmark: details.landmark,
                            city: details.city,
                            state: details.state,
                            country: details.country,
                            postalCode: details.postalCode
                        )
                    }
                }
            }
        }
    }
}
