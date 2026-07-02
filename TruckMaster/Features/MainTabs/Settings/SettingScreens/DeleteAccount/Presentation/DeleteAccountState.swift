//
//  DeleteAccountState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

import Foundation
struct DeleteAccountState {
    var reasons: [DeleteReason] = []
    var selectedReason: DeleteReason?
    var password: String = ""
    var showPasswordSheet = false
    var isPasswordVisible = false
    var isLoading = false

    var isProceedEnabled: Bool {
        selectedReason != nil
    }

    var isDeleteEnabled: Bool {
        !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
