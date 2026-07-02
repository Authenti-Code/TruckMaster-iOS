//
//  ReviewBookingState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 25/06/26.
//

struct CategorySummary: Identifiable {
    let id: Int
    let name: String
    let image: String
    let totalItems: Int
}

struct ReviewBookingState {
    var categorySummaries: [CategorySummary] = []

    var pickupAddress: String = ""
    var dropAddress: String = ""

    var extrasLines: [String] = []

    var termsLines: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet."
    ]

    var showShedule: Bool = false
    var isLoading: Bool = false
    var isSubmitting: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
