//
//  StartShipmentState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

struct StartShipmentState {
    var pickupName: String = ""
    var pickupPhone: String = ""
    var pickupAddress: String = ""
    var user: UserModel?
    var dropAddress: String = ""
    var dropSubAddress: String = ""
    var dropLatitude: Double?
    var dropLongitude: Double?

    var savedAddresses: [SavedAddressModel] = []

    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
