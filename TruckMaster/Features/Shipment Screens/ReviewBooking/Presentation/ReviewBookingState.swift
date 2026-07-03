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

extension CategorySummary {
    static let dummyList: [CategorySummary] = [
        CategorySummary(
            id: 1,
            name: "Furniture",
            image: "https://picsum.photos/id/1060/200/200",
            totalItems: 5
        ),
        CategorySummary(
            id: 2,
            name: "Electronics",
            image: "https://picsum.photos/id/1080/200/200",
            totalItems: 3
        ),
        CategorySummary(
            id: 3,
            name: "Appliances",
            image: "https://picsum.photos/id/1084/200/200",
            totalItems: 2
        ),
        CategorySummary(
            id: 4,
            name: "Boxes & Cartons",
            image: "https://picsum.photos/id/1050/200/200",
            totalItems: 8
        ),
        CategorySummary(
            id: 5,
            name: "Fragile Items",
            image: "https://picsum.photos/id/1025/200/200",
            totalItems: 1
        )
    ]
}
