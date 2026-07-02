//
//  SignUpState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//


import Foundation

struct SignUpState {
    var name:            String       = ""
    var email:           String       = ""
    var phone:           String       = ""
    var password:        String       = ""
    var confirmPassword: String       = ""
    var isAgreed:        Bool         = false
    var isLoading:       Bool         = false
    var showSnackbar:    Bool         = false
    var snackbarMessage: String       = ""
    var snackbarType:    SnackbarType = .error
}
