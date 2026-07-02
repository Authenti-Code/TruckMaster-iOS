//
//  TermCondtionState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 12/06/26.
//

struct TermsConditionState {
    var content:        String       = ""
    var isLoading:      Bool         = false
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error
}
