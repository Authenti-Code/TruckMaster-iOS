//
//  VerifyCodeState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

struct VerifyCodeState {
    var otp:            String       = ""
    var resetToken:     String       = ""
    var isLoading:      Bool         = false
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error
}
