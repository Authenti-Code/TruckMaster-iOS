//
//  EnRouteState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//
struct EnRouteState {
    var orders: [ShipmentModel] = []
    var selectedTab: EnRouteTab = .enRoute
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error

    var filteredOrders: [ShipmentModel] {
        orders.filter {
            selectedTab == .enRoute
                ? $0.status.lowercased() == "en-route"
                : $0.status.lowercased() == "delivered"
        }
    }
}
