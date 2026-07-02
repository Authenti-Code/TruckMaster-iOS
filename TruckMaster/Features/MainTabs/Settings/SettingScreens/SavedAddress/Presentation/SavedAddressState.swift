//
//  SavedAddressState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

struct SavedAddressState {
    var addresses: [SavedAddressModel] = []
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
