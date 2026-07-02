//
//  QuantitiyViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

import Foundation
internal import Combine


@available(iOS 16.0, *)
@MainActor
final class QuantityViewModel: ObservableObject {

    @Published var state = QuantityState()
    let draft: ShipmentDraft

    private let router: AppRouter

    init(categoryId: Int, categoryName: String, subCategories: [SubCategoryModel], draft: ShipmentDraft, router: AppRouter) {
        self.draft = draft
        self.router = router
        self.state.categoryId   = categoryId
        self.state.categoryName = categoryName
        self.state.categories   = subCategories

        state.items = subCategories.map { sub in
            if let existing = draft.items.first(where: {
                $0.categoryId == String(categoryId) && $0.subCategoryId == sub.id
            }) {
                return ItemModel(id: sub.id, count: existing.quantity ?? 0)
            }
            return ItemModel(id: sub.id, count: 0)
        }
    }

    func onAppear() {
        Task { await loadInitialData() }
    }

    func backTapped() {
        router.navigateBack()
    }

    private func loadInitialData() async {

    }

    func plusTapped(subCategoryId: Int) {
        guard let index = state.items.firstIndex(where: { $0.id == subCategoryId }) else { return }
        state.items[index].count += 1
    }

    func minusTapped(subCategoryId: Int) {
        guard let index = state.items.firstIndex(where: { $0.id == subCategoryId }) else { return }
        state.items[index].count = max(0, state.items[index].count - 1)
    }

    func sizesTapped(subCategoryId: Int) {
        state.selectedSubCategoryId = subCategoryId
        state.showSizesSheet = true
    }

    func makeSizesViewModel() -> SizesViewModel? {
        guard let id = state.selectedSubCategoryId,
              let sub = state.categories.first(where: { $0.id == id }) else { return nil }
        return SizesViewModel(
            categoryId: state.categoryId,
            subCategoryId: sub.id,
            itemCount: state.items.first(where: { $0.id == id })?.count ?? 0,
            subCategoryName: sub.name,
            draft: draft,
            router: router
        )
    }

    func nextTapped() {
        let selectedItems = state.items.filter { $0.count > 0 }
//        guard !selectedItems.isEmpty else {
//            triggerError("Select at least one item")
//            return
//        }
        if state.showSizesSheet{
            syncToDraft()
        }
        router.navigateBack()
    }

    // MARK: - Private
    private func syncToDraft() {
        let categoryIdString = String(state.categoryId)

        for item in state.items {
            let existingIndex = draft.items.firstIndex(where: {
                $0.categoryId == categoryIdString && $0.subCategoryId == item.id
            })

            if item.count == 0 {
                if let existingIndex {
                    draft.items.remove(at: existingIndex)
                }
                continue
            }

            if let existingIndex {
               let existing = draft.items[existingIndex]
                draft.items[existingIndex] = ItemRequest(
                    categoryId: existing.categoryId,
                    subCategoryId: existing.subCategoryId,
                    quantity: item.count,
                    dimensions: existing.dimensions,
                    dimensionUnit: existing.dimensionUnit
                )
            } else {
                 draft.items.append(ItemRequest(
                    categoryId: categoryIdString,
                    subCategoryId: item.id,
                    quantity: item.count,
                    dimensions: [],
                    dimensionUnit: nil
                ))
            }
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
