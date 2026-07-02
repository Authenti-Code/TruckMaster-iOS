//
//  SelectCategoryState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

struct SelectCategoryState {

    var categories: [CategoryModel] = []
    var totalPages: Int = 1
    var pickupName: String = ""
    var pickupPhone: String = ""
    var pickupAddress: String = ""

    var dropName: String = ""
    var dropPhone: String = ""
    var dropAddress: String = ""

    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
