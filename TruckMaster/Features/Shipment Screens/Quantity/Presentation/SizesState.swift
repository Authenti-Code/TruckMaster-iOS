//
//  SizesState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

internal import Foundation

struct SizesState {
    var categoryId: Int = 0
    var subCategoryId: Int = 0
    var itemCount: Int = 0
    var subCategoryName: String = ""
    var isLoading: Bool = false
    var selectedUnit: MeasurementUnit = .m
    var dimensions: [SizeDimension] = [] 
    var applySameDimensions: Bool = false
    
    var snackbarMessage: String = ""
    var snackbarType: SnackbarType = .error
    var showSnackbar: Bool = false
}

struct SizeDimension {
    var widthInCm: String = ""
    var lengthInCm: String = ""
}
