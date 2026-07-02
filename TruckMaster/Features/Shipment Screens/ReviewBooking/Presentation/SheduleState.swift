//
//  SheduleState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 26/06/26.
//

import Foundation

struct SheduleState {
    var instantBooking: Bool = false
    var sheduleBooking: Bool = false
    var scheduleType: String = ""
    var selectedDate: Date = Date()
    var selectedTime: Date = Date()

    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
