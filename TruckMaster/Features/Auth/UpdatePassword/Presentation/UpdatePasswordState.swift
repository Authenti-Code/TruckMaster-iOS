//
//  VerifyCodeState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

struct UpdatePasswordState {
    var resetToken:     String       = ""
    var password:     String       = ""
    var confirmPassword:     String       = ""
    var isLoading:      Bool         = false
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error
}
