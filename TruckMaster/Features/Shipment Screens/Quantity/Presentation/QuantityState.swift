//
//  QuantityState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

struct QuantityState {
    var categoryId: Int = 0
    var categoryName: String = ""
    var categories: [SubCategoryModel] = []
    var items: [ItemModel] = []
    var selectedSubCategoryId: Int? = nil
    var showSizesSheet = false
    var isLoading: Bool = false
    var showSnackbar: Bool = false
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
}
