//
//  OrderState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//


internal import SwiftUI

// MARK: - State
struct OrderState {
    var orders:         [OrderModel] = []
    var isLoading:      Bool         = false
    var isRefreshing:   Bool         = false
    var isLoadingMore:  Bool         = false
    var hasMoreData:    Bool         = true
    var currentPage:    Int          = 1
    var showSnackbar:   Bool         = false
    var snackbarMessage: String      = ""
    var snackbarType:   SnackbarType = .error
}
