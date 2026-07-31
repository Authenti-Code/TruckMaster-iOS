//
//  SignInState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//


internal import Foundation

struct SignInState {
    var email:          String       = ""
    var password:       String       = ""
    var isLoading:      Bool         = false
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error
}
