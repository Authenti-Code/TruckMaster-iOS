//
//  LocationManager.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//
//


import CoreLocation
internal import Combine

struct LocationAddressDetails {
    let address: String
    let latitude: Double
    let longitude: Double
    let city: String?
    let state: String?
    let country: String?
    let postalCode: String?
    let landmark: String?
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    static let shared = LocationManager()

    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    @Published var currentLocation: CLLocation?

    @Published var locationName: String = ""
    @Published var currentAddress: String = ""
    @Published var currentAddressDetails: LocationAddressDetails?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    // MARK: - Request Permission
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    // MARK: - Start
    func startUpdating() {
        manager.startUpdatingLocation()
    }

    // MARK: - Stop
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    // MARK: - Delegate
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        currentLocation = location
        manager.stopUpdatingLocation()
        reverseGeocode(location: location)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        authorizationStatus = status
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdating()
        case .denied, .restricted:
            locationName = "Location unavailable"
        default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationName = "Location unavailable"
    }

    // MARK: - Reverse Geocode
    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            guard error == nil,
                  let placemark = placemarks?.first else {
                self.locationName = "Location unavailable"
                self.currentAddress = "Location unavailable"
                self.currentAddressDetails = nil
                return
            }

            let city    = placemark.locality ?? ""
            let country = placemark.country  ?? ""

            let streetNumber = placemark.subThoroughfare ?? ""
            let street       = placemark.thoroughfare ?? ""
            let subLocality  = placemark.subLocality ?? ""
            let postalCode   = placemark.postalCode ?? ""
            let stateName    = placemark.administrativeArea ?? ""

            let fullAddress = [streetNumber, street, subLocality, city, postalCode, country]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")

            let latitude  = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            DispatchQueue.main.async {
                self.locationName = [city, country]
                    .filter { !$0.isEmpty }
                    .joined(separator: ", ")
                self.currentAddress = fullAddress
                self.currentAddressDetails = LocationAddressDetails(
                    address: fullAddress,
                    latitude: latitude,
                    longitude: longitude,
                    city: city.isEmpty ? nil : city,
                    state: stateName.isEmpty ? nil : stateName,
                    country: country.isEmpty ? nil : country,
                    postalCode: postalCode.isEmpty ? nil : postalCode,
                    landmark: subLocality.isEmpty ? nil : subLocality
                )
            }
        }
    }
}
