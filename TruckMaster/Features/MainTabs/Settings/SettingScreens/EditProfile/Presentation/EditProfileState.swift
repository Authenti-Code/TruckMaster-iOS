//
//  EditProfileState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

import UIKit

struct EditProfileState {
    var name: String = ""
    var email: String = ""
    var contact: String = ""
    var profileImg: String = ""
    var selectedImage:  UIImage?     = nil 
    var isLoading:      Bool         = false
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error
}
