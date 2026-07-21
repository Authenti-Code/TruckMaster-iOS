//
//  MapAddressViewModel.swift
//  TruckMaster
//

import Foundation
import GoogleMaps
import CoreLocation
internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class MapAddressViewModel: NSObject, ObservableObject {

    @Published var state = MapAddressState()
    private let draft: ShipmentDraft
    private let router: AppRouter
    private let isUpdatingLocation: Bool
    let comingFrom: ComingFrom
    private let locationManager = CLLocationManager()
    private var didCenterOnUser = false
    private var isUserDrag = false
    @Published var nameError: String?

    private static let allowedDigits = Set("0123456789")

    init(router: AppRouter, isUpdatingLocation: Bool, comingFrom: ComingFrom, draft: ShipmentDraft) {
        self.router = router
        self.isUpdatingLocation = isUpdatingLocation
        self.comingFrom = comingFrom
        self.draft = draft
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func onAppear() {
        guard state.selectedAddress.isEmpty else { return }
        print("Coming from", comingFrom)
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    var nameBinding: Binding<String> {
        Binding(
            get: { self.state.name },
            set: { self.handleNameChange($0) }
        )
    }

    var contactBinding: Binding<String> {
        Binding(
            get: { self.state.contact },
            set: { newValue in
                self.state.contact = newValue.filter { Self.allowedDigits.contains($0) }
            }
        )
    }

    private func handleNameChange(_ newValue: String) {
        var filtered = newValue

        while let first = filtered.first, first == " " {
            filtered.removeFirst()
        }

        Task { @MainActor in
            self.state.name = filtered
            self.validateNameRealTime()
        }
    }

    private func validateNameRealTime() {
        let trimmed = state.name.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            nameError = nil
        } else if trimmed.count < 3 {
            nameError = "Name must be at least 3 characters"
        } else {
            nameError = nil
        }
    }

    func backTapped() {
        if state.isDetailsStage {
            state.isDetailsStage = false
        }
        else {
            router.navigateBack()
        }
    }

    func confirmLocationTapped() {

        let location = SelectedLocation(
            latitude: state.camera.target.latitude,
            longitude: state.camera.target.longitude,
            address: state.selectedAddress,
            subAddress: state.selectedSubAddress
        )

        guard isUpdatingLocation else {
            router.navigate(to: .addNewAddress(location: location))
            return
        }

        if (comingFrom == .shipmentPickup || comingFrom == .shipmentDrop), !state.isDetailsStage {
            if comingFrom == .shipmentPickup {
                let user = UserPreferences.shared.getUser()
                state.name    = user?.name ?? ""
                state.contact = user?.phoneNumber ?? ""
            }
            state.isDetailsStage = true
            return
        }

        if comingFrom == .shipmentPickup || comingFrom == .shipmentDrop {
            guard isFormValid else {
                let trimmedName = state.name.trimmingCharacters(in: .whitespacesAndNewlines)

                let message: String
                if trimmedName.isEmpty {
                    nameError = "Name is required"
                    message = "Name is required"
                } else if trimmedName.count < 3 {
                    nameError = "Name must be at least 3 characters"
                    message = "Name must be at least 3 characters"
                } else {
                    nameError = nil
                    message = "Enter a valid 10-digit contact number"
                }

                triggerError(message)
                return
            }
        }

        var payload = AddressPayload(
            address: state.selectedSubAddress.isEmpty ? state.selectedAddress : state.selectedSubAddress,
            latitude: String(state.selectedLatitude),
            longitude: String(state.selectedLongitude),
            landmark: state.selectedLandmark,
            city: state.selectedCity,
            state: state.selectedState,
            country: state.selectedCountry,
            postalCode: state.selectedPostalCode
        )

        router.pendingLocationUpdate = location

        switch comingFrom {
        case .shipmentPickup:
            payload.name        = state.name
            payload.contact = state.contact
            payload.label       = state.selectedLabel.rawValue
            draft.pickup = payload
            router.navigateBack()

        case .shipmentDrop:
            payload.name        = state.name
            payload.contact = state.contact
            payload.label       = state.selectedLabel.rawValue
            draft.dropoff = payload
            print("Payload: \(draft)")

            router.navigate(to: .selectCategory)

        case .addressChangeAddress:
            router.navigateBack()

        default:
            break
        }
    }

    func searchTapped() {
        // open GMSAutocompleteViewController when API key ready
    }

    func currentLocationTapped() {
        guard let location = locationManager.location else {
            triggerError("Unable to get current location")
            return
        }

        isUserDrag = false
        state.shouldAnimateCamera = true
        state.camera = GMSCameraPosition(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 16
        )
        state.shouldAnimateCamera = false
        reverseGeocode(location.coordinate)
    }

    func onCameraWillMove() {
        isUserDrag = true
    }

    func onCameraIdle(_ position: GMSCameraPosition) {
        guard isUserDrag else { return }
        isUserDrag = false
        reverseGeocode(position.target)
    }

    var isContactValid: Bool {
        let digits = state.contact.filter(\.isNumber)
        return digits.count == 10
    }

    var isFormValid: Bool {
        state.name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 &&
        isContactValid
    }

    // MARK: - Private

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self, let placemark = placemarks?.first else { return }

            let name = placemark.name ?? placemark.locality ?? "Unknown"
            let address = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode
            ]
            .compactMap { $0 }
            .joined(separator: " ")

            Task { @MainActor in
                self.state.selectedAddress    = name
                self.state.selectedSubAddress = address

                self.state.selectedLatitude   = coordinate.latitude
                self.state.selectedLongitude  = coordinate.longitude
                self.state.selectedLandmark   = placemark.subLocality
                self.state.selectedCity       = placemark.locality
                self.state.selectedState      = placemark.administrativeArea
                self.state.selectedCountry    = placemark.country
                self.state.selectedPostalCode = placemark.postalCode
            }
        }
    }

    private func triggerError(_ message: String) {
        UIApplication.shared.endEditing()
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}

@available(iOS 16.0, *)
extension MapAddressViewModel: CLLocationManagerDelegate {

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            case .denied, .restricted:
                self.triggerError("Location permission denied. Enable it in Settings.")
            default:
                break
            }
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        Task { @MainActor in
            guard !self.didCenterOnUser else { return }

            self.didCenterOnUser = true

            self.state.shouldAnimateCamera = true
            self.state.camera = GMSCameraPosition(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                zoom: 16
            )
            self.state.shouldAnimateCamera = false

            self.reverseGeocode(location.coordinate)

            manager.stopUpdatingLocation()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.triggerError("Failed to get location")
        }
    }
}
