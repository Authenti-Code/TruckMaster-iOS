//
//  ForgotPasswordState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import Foundation

struct ForgotPasswordState {
    var email:           String = ""
    var isLoading:       Bool   = false
    var showSnackbar:    Bool   = false
    var snackbarMessage: String = ""
    var snackbarType:    SnackbarType = .error
}
