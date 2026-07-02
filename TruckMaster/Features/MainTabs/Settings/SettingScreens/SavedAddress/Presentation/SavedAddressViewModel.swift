//
//  SavedAddressViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class SavedAddressViewModel: ObservableObject {


    @Published var state = SavedAddressState()

    private let useCase: GetSavedAddressesUseCase
    private let router: AppRouter

    init(useCase: GetSavedAddressesUseCase, router: AppRouter) {
        self.useCase = useCase
        self.router  = router
    }

    func onAppear() {
        Task { await loadAddresses() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func addAddressTapped() {
        router.navigate(to: .addAddress(isUpdatingLocation: false, comingFrom: .addAddress))
    }
    
    func editAddressTapped(_ address: SavedAddressModel) {
        let location = SelectedLocation(
            latitude: Double(address.latitude) ?? 0.0,
            longitude: Double(address.longitude) ?? 0.0,
            address: address.address,
            subAddress: address.subAddress
        )
        router.navigate(to: .addNewAddress(location: location, editingAddress: address))
    }

    func deleteAddressTapped(_ address: SavedAddressModel) {
        Task { await deleteAddress(address) }
    }

    // MARK: - Private
    private func loadAddresses() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.addresses = try await useCase.execute()
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func deleteAddress(_ address: SavedAddressModel) async {
           do {
               _ = try await useCase.executeDeleteAddress(id: address.id)
               state.addresses.removeAll { $0.id == address.id }
//               triggerSuccess("Address deleted successfully")
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
