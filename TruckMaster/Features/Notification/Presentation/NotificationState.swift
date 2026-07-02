//
//  NotificationState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

struct NotificationState {
    var notifications: [NotificationModel] = []
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
