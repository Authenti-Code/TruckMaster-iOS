//
//  DeliveredDetailState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/07/26.
//

struct DeliveredDetailState{
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
    var isPriceDetailVisible: Bool = false
    var categorySummaries: [CategorySummary] = []
    var items: [String] = ["2 Helper", "No"]
}


