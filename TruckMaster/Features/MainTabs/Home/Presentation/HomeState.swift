//
//  HomeState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

internal import SwiftUI

// MARK: - State
struct HomeState {
    var shipments:      [ShipmentModel] = []
    var profileData:      ProfileResponse? = nil
    var isLoading:      Bool            = false
    var isRefreshing:   Bool            = false
    var locationName:   String          = ""
    var address:        String          = ""
    var latitude:        Double          = 0.0
    var longitude:        Double          = 0.0
    var userName:       String          = ""
    var showSnackbar:   Bool            = false
    var snackbarMessage: String         = ""
    var snackbarType:   SnackbarType    = .error
}
