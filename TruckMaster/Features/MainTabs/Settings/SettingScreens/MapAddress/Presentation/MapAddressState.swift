//
//  MapAddressState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import GoogleMaps

struct MapAddressState {
    var searchText: String = ""
    var selectedAddress: String = ""
    var selectedSubAddress: String = ""
    var name: String = ""
    var contact: String = ""
    var camera: GMSCameraPosition = GMSCameraPosition(
        latitude: 37.7749,
        longitude: -122.4194,
        zoom: 15
    )
    var selectedLabel: AddressLabel = .home
    var currentLocation: CLLocation?
    var shouldAnimateCamera: Bool = true
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var isDetailsStage: Bool = false
    var snackbarMessage: String = ""
    var isShipment: Bool = false
    var snackbarType: SnackbarType = .error


    var selectedLatitude: Double = 0
    var selectedLongitude: Double = 0
    var selectedLandmark: String?
    var selectedCity: String?
    var selectedState: String?
    var selectedCountry: String?
    var selectedPostalCode: String?
    
    
}
