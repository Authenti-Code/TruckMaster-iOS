//
//  FeedBackState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 02/07/26.
//

struct FeedBackState {
    
    var thoughts: String = ""
    var userRating: Int = -1
    
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
