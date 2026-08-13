//
//  SizesViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

internal import Foundation
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
             let savedUnit = MeasurementUnit.allCases.first(where: { $0.apiValue == existing.dimensionUnit }) ?? .m

             var prefilled = existing.dimensions.map { dim in
                 SizeDimension(
                     widthInCm: Self.toCm(dim.width, from: savedUnit),
                     lengthInCm: Self.toCm(dim.length, from: savedUnit)
                 )
             }

             if prefilled.count < itemCount {
                 prefilled.append(contentsOf: Array(repeating: SizeDimension(), count: itemCount - prefilled.count))
             } else if prefilled.count > itemCount {
                 prefilled = Array(prefilled.prefix(itemCount))
             }

             state.dimensions = prefilled
             state.selectedUnit = savedUnit
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
        case .m:    return String(format: "%.2f", cm / 100)
        case .inch: return String(format: "%.1f", cm / 2.54)
        }
    }


    private func convertToCm(_ input: String) -> String {
        guard let value = Double(input) else { return "" }
        switch state.selectedUnit {
        case .m:    return String(value * 100)
        case .inch: return String(value * 2.54)
        }
    }

    // Converts a value stored/saved in a given unit back into the
    // canonical cm representation used internally by `state.dimensions`.
    private static func toCm(_ value: String, from unit: MeasurementUnit) -> String {
        guard let v = Double(value) else { return "" }
        switch unit {
        case .m:    return String(v * 100)
        case .inch: return String(v * 2.54)
        }
    }

    // Converts an internally-stored cm value back into whichever unit
    // is currently selected, so the outgoing request's value and its
    // unit tag always match.
    private func convertFromCm(_ cmString: String) -> String {
        guard let cm = Double(cmString) else { return cmString }
        switch state.selectedUnit {
        case .m:    return String(format: "%.4f", cm / 100)
        case .inch: return String(format: "%.4f", cm / 2.54)
        }
    }

    var isDoneEnabled: Bool {
        state.dimensions.allSatisfy { !$0.widthInCm.isEmpty && !$0.lengthInCm.isEmpty }
    }

    private var isWithinValidRange: Bool {
        state.dimensions.allSatisfy { dim in
            guard let w = Double(displayValue(forCm: dim.widthInCm)),
                  let l = Double(displayValue(forCm: dim.lengthInCm)) else { return false }
            return (1...1000).contains(w) && (1...1000).contains(l)
        }
    }

    func saveTapped() -> Bool {
        guard isDoneEnabled else {
            triggerError("Enter width and length for all items")
            return false
        }

        guard isWithinValidRange else {
            triggerError("Width and length must be between 1 and 1000")
            return false
        }

        let dimensionRequests: [DimensionRequest] = state.dimensions.map {
            DimensionRequest(
                width: convertFromCm($0.widthInCm),
                length: convertFromCm($0.lengthInCm)
            )
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
        } else {
            clearAllDimensions()
        }
    }

    private func clearAllDimensions() {
        for index in state.dimensions.indices {
            state.dimensions[index] = SizeDimension()
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
