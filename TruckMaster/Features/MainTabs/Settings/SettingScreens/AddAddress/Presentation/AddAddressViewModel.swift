//
//  AddAddressViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//
internal import Foundation
internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class AddAddressViewModel: ObservableObject {

    @Published var state = AddAddressViewState()
    private let router: AppRouter
    private let addAddressUseCase: AddAddressUseCase
    private let editingAddress: SavedAddressModel?

    private static let allowedDigits = Set("0123456789")

    var isEditMode: Bool { editingAddress != nil }

    init(
        addAddressUseCase: AddAddressUseCase,
        router: AppRouter,
        location: SelectedLocation,
        editingAddress: SavedAddressModel? = nil
    ) {
        self.addAddressUseCase = addAddressUseCase
        self.router = router
        self.editingAddress = editingAddress

        state.longitude = location.longitude
        state.latitude = location.latitude
        state.selectedAddress = location.address
        state.selectedSubAddress = location.subAddress

        if let editingAddress {
            state.name = editingAddress.name
            state.phone = editingAddress.phoneNumber ??  state.phone
            state.selectedLabel = AddressLabel(rawValue: editingAddress.label.lowercased()) ?? .home
        }
    }

    func onAppear() {
        guard let updated = router.pendingLocationUpdate else { return }
        state.latitude = updated.latitude
        state.longitude = updated.longitude
        state.selectedAddress = updated.address
        state.selectedSubAddress = updated.subAddress
        router.pendingLocationUpdate = nil
    }

    var nameBinding: Binding<String> {
        Binding(
            get: { self.state.name },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.name = newValue
                
            }
        )
    }

   
    var phoneBinding: Binding<String> {
        Binding(
            get: { self.state.phone },
            set: { newValue in
                self.state.phone = newValue.filter { Self.allowedDigits.contains($0) }
            }
        )
    }

    func backTapped() {
        router.navigateBack()
    }

    func changeTapped() {
        router.navigate(to: .addAddress(isUpdatingLocation: true, comingFrom: .addressChangeAddress))
    }

    func addBtnTapped() {
        guard validateFields() else { return }

        Task {
            await saveAddress()
        }
    }
    private func validateFields() -> Bool {

        let name = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = state.phone.trimmingCharacters(in: .whitespacesAndNewlines)

        if name.isEmpty {
            triggerError("Name is required")
            return false
        }

        if name.count < 3 {
            triggerError("Name must be at least 3 characters")
            return false
        }

        if phone.isEmpty {
            triggerError("Contact is required")
            return false
        }

        if phone.count != 10 {
            triggerError("Contact must be exactly 10 digits")
            return false
        }

        return true
    }
    private func saveAddress() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            if let editingAddress {
                let request = UpdateAddressRequest(
                    address: state.selectedAddress,
                    subAddress:  state.selectedSubAddress,
                    name: state.name,
                    latitude: "\(state.latitude)",
                    longitude: "\(state.longitude)",
                    phoneNumber: state.phone,
                    label: state.selectedLabel.rawValue,
                    addressId: "\(editingAddress.id)"
                )
                _ = try await addAddressUseCase.executeUpdateAddress(request: request)
//                triggerSuccess("Address updated successfully")
            } else {
                let request = AddAddressRequest(
                    address: state.selectedAddress,
                    subAddress:  state.selectedSubAddress,
                    name: state.name,
                    phoneNumber: state.phone,
                    label: state.selectedLabel.rawValue,
                    latitude: "\(state.latitude)",
                    longitude: "\(state.longitude)"
                )
                _ = try await addAddressUseCase.execute(request: request)
//                triggerSuccess("Address added successfully")
            }

            try? await Task.sleep(nanoseconds: 1_000_000_000)
            router.navigateBack(2)
        } catch {
            triggerError(error.localizedDescription)
        }
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
}
