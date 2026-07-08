//
//  ExtrasState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 24/06/26.
//

struct ExtrasState {
    var helpers: Int = 0
    var fragileHandling: Bool = false
    var stairsCarry: Bool = false
    var urgent: Bool = false
    var zipHandler: Bool = false
    var elevator: Bool = false
    var additionalInfo: String? = nil

    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
