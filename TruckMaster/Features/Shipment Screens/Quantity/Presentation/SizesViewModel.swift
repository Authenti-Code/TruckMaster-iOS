//
//  SizesViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

import Foundation
internal import Combine
@available(iOS 16.0, *)
@MainActor
final class SizesViewModel: ObservableObject {

    @Published var state = SizesState()
    let draft: ShipmentDraft

    private let router: AppRouter

    init(categoryId: Int, subCategoryId: Int, itemCount: Int, subCategoryName: String, draft: ShipmentDraft, router: AppRouter) {
         self.draft = draft
         self.router = router
         self.state.categoryId = categoryId
         self.state.subCategoryId = subCategoryId
         self.state.itemCount = itemCount
         self.state.subCategoryName = subCategoryName

         if let existing = draft.items.first(where: { $0.subCategoryId == subCategoryId }) {
             var prefilled = existing.dimensions.map {
                 SizeDimension(widthInCm: String($0.width), lengthInCm: String($0.length))
             }

             if prefilled.count < itemCount {
                 prefilled.append(contentsOf: Array(repeating: SizeDimension(), count: itemCount - prefilled.count))
             } else if prefilled.count > itemCount {
                 prefilled = Array(prefilled.prefix(itemCount))
             }

             state.dimensions = prefilled
         } else {
             state.dimensions = Array(repeating: SizeDimension(), count: itemCount)
         }
     }

    func unitChanged(to unit: MeasurementUnit) {
        state.selectedUnit = unit
    }

    func displayValue(forCm cmString: String) -> String {
        guard let cm = Double(cmString), cm > 0 else { return "" }
        switch state.selectedUnit {
        case .cm:   return String(format: "%.1f", cm)
        case .m:    return String(format: "%.2f", cm / 100)
        case .inch: return String(format: "%.1f", cm / 2.54)
        }
    }


    private func convertToCm(_ input: String) -> String {
        guard let value = Double(input) else { return "" }
        switch state.selectedUnit {
        case .cm:   return String(value)
        case .m:    return String(value * 100)
        case .inch: return String(value * 2.54)
        }
    }

    var isDoneEnabled: Bool {
        state.dimensions.allSatisfy { !$0.widthInCm.isEmpty && !$0.lengthInCm.isEmpty }
    }

    func saveTapped() -> Bool {
        guard isDoneEnabled else {
            triggerError("Enter width and length for all items")
            return false
        }

        let dimensionRequests: [DimensionRequest] = state.dimensions.map {
            DimensionRequest(width: $0.widthInCm, length: $0.lengthInCm)
        }

        let item = ItemRequest(
            categoryId: String(state.categoryId),
            subCategoryId: state.subCategoryId,
            quantity: state.dimensions.count,
            dimensions: dimensionRequests,
            dimensionUnit: state.selectedUnit.apiValue
        )

        if let existingIndex = draft.items.firstIndex(where: { $0.subCategoryId == state.subCategoryId }) {
            draft.items[existingIndex] = item
        } else {
            draft.items.append(item)
        }

        print("Draft: \(draft)")
        return true
    }
    
    
    func sameDimensionsToggled(_ isOn: Bool) {
        state.applySameDimensions = isOn
        if isOn {
            applyFirstDimensionToAll()
        }
    }

    private func applyFirstDimensionToAll() {
        guard let first = state.dimensions.first else { return }
        for index in state.dimensions.indices {
            state.dimensions[index] = first
        }
    }

    func updateWidth(at index: Int, fromInput input: String) {
        guard state.dimensions.indices.contains(index) else { return }
        let cm = convertToCm(input)
        if state.applySameDimensions {
            for i in state.dimensions.indices { state.dimensions[i].widthInCm = cm }
        } else {
            state.dimensions[index].widthInCm = cm
        }
    }

    func updateLength(at index: Int, fromInput input: String) {
        guard state.dimensions.indices.contains(index) else { return }
        let cm = convertToCm(input)
        if state.applySameDimensions {
            for i in state.dimensions.indices { state.dimensions[i].lengthInCm = cm }
        } else {
            state.dimensions[index].lengthInCm = cm
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
