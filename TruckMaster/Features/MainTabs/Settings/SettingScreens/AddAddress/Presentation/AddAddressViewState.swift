//
//  AddAddressViewState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//


struct AddAddressViewState {
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error

 
    var name: String = ""
    var phone: String = ""
    var selectedLabel: AddressLabel = .home


    var selectedAddress: String = ""
    var selectedSubAddress: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
}
