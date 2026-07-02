//
//  ChangePasswordState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct ChangePasswordState {
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
