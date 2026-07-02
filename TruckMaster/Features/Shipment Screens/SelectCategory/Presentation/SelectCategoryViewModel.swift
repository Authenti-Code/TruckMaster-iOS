//
//  SelectCategoryViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

import Foundation
internal import Combine
@available(iOS 16.0, *)
@MainActor
final class SelectCategoryViewModel: ObservableObject {

    @Published var state = SelectCategoryState()
    let draft: ShipmentDraft

    private let getCategoryUseCase: NewCategoryUseCase
    private let router: AppRouter
    private var hasLoadedCategories = false

    init(
        getCategoryUseCase: NewCategoryUseCase,
        draft: ShipmentDraft,
        router: AppRouter
    ) {
        self.getCategoryUseCase = getCategoryUseCase
        self.draft = draft
        self.router = router
    }

    func onAppear() {
        prefillAddresses()
        guard !hasLoadedCategories else { return }
        Task { await loadInitialData() }
    }

    func backTapped() {
        router.navigateBack()
    }
    
    func categoryTapped(_ category: CategoryModel) {
        router.navigate(to: .quantity(categoryId: category.id, categoryName: category.name, subCategories: category.subCategories))
    }

    private func prefillAddresses() {
        state.pickupName    = draft.pickup?.name ?? ""
        state.pickupPhone   = draft.pickup?.contact ?? ""
        state.pickupAddress = draft.pickup?.address ?? ""

        state.dropName    = draft.dropoff?.name ?? ""
        state.dropPhone   = draft.dropoff?.contact ?? ""
        state.dropAddress = draft.dropoff?.address ?? ""
    }

    func selectedItems(for categoryId: Int) -> [ItemRequest] {
        draft.items.filter { $0.categoryId == String(categoryId) }
    }
    
    private func loadInitialData() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = CategoryListRequest(limit: "10", page: "1")

        do {
            let result = try await getCategoryUseCase.execute(request: request)
            state.categories = result.categories
            state.totalPages = result.totalPages
            hasLoadedCategories = true
        } catch {
            triggerError(error.localizedDescription)
        }
    }
    
    func proceedTapped() {
        router.navigate(to: .extras)
    }


    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
