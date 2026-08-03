//
//  OrderDetailState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

struct OrderDetailState {
    var order: OrderOfferDetail? = nil
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
