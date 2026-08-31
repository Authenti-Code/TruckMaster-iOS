//
//  RaiseTicketState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

internal import Foundation

struct RaiseTicketState {
    var title: String = ""
    var description: String = ""
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
    var showSnackbar: Bool = false
    var isLoading: Bool = false
}
