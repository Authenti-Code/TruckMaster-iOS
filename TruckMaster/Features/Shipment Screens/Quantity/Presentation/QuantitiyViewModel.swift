//
//  QuantitiyViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

internal import Foundation
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
    
    func toggleTapped(subCategoryId: Int) {
        if let index = state.items.firstIndex(where: { $0.id == subCategoryId }) {
            state.items[index].count = state.items[index].count > 0 ? 0 : 1
        }
    }

    func plusTapped(subCategoryId: Int) {
        guard let index = state.items.firstIndex(where: { $0.id == subCategoryId }) else {
            return
        }

        state.items[index].count += 1
        updateDraft(for: state.items[index])
    }
    
    func minusTapped(subCategoryId: Int) {
        guard let index = state.items.firstIndex(where: { $0.id == subCategoryId }) else {
            return
        }

        state.items[index].count = max(0, state.items[index].count - 1)
        updateDraft(for: state.items[index])
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

        guard !selectedItems.isEmpty else {
            triggerError("Select at least one item")
            return
        }

        if state.categoryName == "full move" {
            for item in selectedItems {
                if let index = draft.items.firstIndex(where: {
                    $0.categoryId == String(state.categoryId) &&
                    $0.subCategoryId == item.id
                }) {
                    draft.items[index].dimensions = [DimensionRequest(width: "0", length: "0")]
                    draft.items[index].quantity = 1
                } else {
                    draft.items.append(
                        ItemRequest(
                            categoryId: String(state.categoryId),
                            subCategoryId: item.id,
                            quantity: 1,
                            dimensions: [DimensionRequest(width: "1", length: "1")],
                            dimensionUnit: "m"
                        )
                    )
                }
            }
            router.navigateBack()
            return
        }

        for item in selectedItems {
            guard
                let draftItem = draft.items.first(where: {
                    $0.categoryId == String(state.categoryId) &&
                    $0.subCategoryId == item.id
                }),
                draftItem.dimensions.count == item.count
            else {
                triggerError("Please enter dimensions for all selected items.")
                return
            }
        }

        router.navigateBack()
    }
    
    // MARK: - Private
    private func updateDraft(for item: ItemModel) {

        let categoryId = String(state.categoryId)

        if let index = draft.items.firstIndex(where: {
            $0.categoryId == categoryId &&
            $0.subCategoryId == item.id
        }) {

            if item.count == 0 {

                draft.items.remove(at: index)

            } else {

                var existing = draft.items[index]
                existing.quantity = item.count


                if existing.dimensions.count > item.count {
                    existing.dimensions = Array(existing.dimensions.prefix(item.count))
                }

                draft.items[index] = existing
            }

        } else if item.count > 0 {

            draft.items.append(
                ItemRequest(
                    categoryId: categoryId,
                    subCategoryId: item.id,
                    quantity: item.count,
                    dimensions: [],
                    dimensionUnit: nil
                )
            )
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
