//
//  DeleteAccountState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import Foundation
struct DeleteAccountState {
    var reasons: [DeleteReason] = []
    var selectedReason: DeleteReason?
    var password: String = ""
    var showPasswordSheet = false
    var isPasswordVisible = false
    var isLoading = false
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error

    var isProceedEnabled: Bool {
        selectedReason != nil
    }

    var isDeleteEnabled: Bool {
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    
}
