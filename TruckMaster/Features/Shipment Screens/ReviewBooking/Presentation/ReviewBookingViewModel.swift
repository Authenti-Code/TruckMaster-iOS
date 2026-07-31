//
//  ReviewBookingViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 25/06/26.
//

internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class ReviewBookingViewModel: ObservableObject {

    @Published var state = ReviewBookingState()
    let draft: ShipmentDraft

    private let getCategoryUseCase: NewCategoryUseCase
    private let router: AppRouter

    private let createOrderUseCase: CreateOrderUseCase

    init(
        getCategoryUseCase: NewCategoryUseCase,
        createOrderUseCase: CreateOrderUseCase,
        draft: ShipmentDraft,
        router: AppRouter
    ) {
        self.getCategoryUseCase = getCategoryUseCase
        self.createOrderUseCase = createOrderUseCase
        self.draft = draft
        self.router = router

        state.pickupAddress = draft.pickup?.address ?? ""
        state.dropAddress = draft.dropoff?.address ?? ""
        buildExtrasLines()
    }

    func makeScheduleViewModel() -> SheduleViewModel {
        SheduleViewModel(
            draft: draft,
            router: router,
            createOrderUseCase: createOrderUseCase
        )
    }

    func onAppear() {
        Task { await loadCategoriesAndBuildSummary() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func sendRequestTapped() {
        guard let request = draft.buildRequest() else {
            triggerError("Please complete pickup, drop, and at least one item before sending.")
            return
        }

        state.isSubmitting = true
        state.showShedule = true
        // Task { await submit(request) } — wire to your create-shipment use case here
        print("Submitting: \(request)")
    }

    private func loadCategoriesAndBuildSummary() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = CategoryListRequest(limit: "10", page: "1")

        do {
            let result = try await getCategoryUseCase.execute(request: request)
            buildCategorySummaries(from: result.categories)
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    
    private func buildCategorySummaries(from categories: [CategoryModel]) {
        let groupedByCategory = Dictionary(grouping: draft.items, by: { $0.categoryId })

        let summaries: [CategorySummary] = groupedByCategory.compactMap { categoryIdString, items in
            guard let categoryId = Int(categoryIdString),
                  let category = categories.first(where: { $0.id == categoryId }) else { return nil }

            let totalItems = items.reduce(0) { $0 + ($1.quantity ?? 0) }

            return CategorySummary(
                id: category.id,
                name: category.name.capitalized,
                image: category.image,
                totalItems: totalItems
            )
        }

        state.categorySummaries = summaries.sorted { $0.id < $1.id }
    }

    private func buildExtrasLines() {
        var lines: [String] = []
        if draft.extras.helpers > 0 {
            lines.append("\(draft.extras.helpers) Helper\(draft.extras.helpers == 1 ? "" : "s")")
        }
        if draft.extras.fragileHandling { lines.append("Fragile Handling") }
        if draft.extras.stairsCarry     { lines.append("Stairs Carry") }
        if draft.extras.urgent          { lines.append("Urgent") }
        if draft.extras.zipHandler      { lines.append("Zip Handler") }
        lines.append(draft.extras.elevator ? "Elevator: Yes" : "Elevator: No")
        if let additionalInfo = draft.extras.additionalInfo,
           !additionalInfo.isEmpty {
            lines.append(additionalInfo)
        }
        state.extrasLines = lines
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
