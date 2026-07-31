//
//  DeliveredDetailViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/07/26.
//
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
final class DeliveredDetailViewModel: ObservableObject {

    @Published var state = DeliveredDetailState()

    private let router: AppRouter

    init(
        router: AppRouter
    ) {
        self.router = router
    }

    

    func onAppear() {
        Task { await loadData() }
    }

    func backTapped() {
        router.navigateBack()
    }
    
    func priceBreakUpTapped() {
        state.isPriceDetailVisible.toggle()
    }


    private func loadData() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = CategoryListRequest(limit: "10", page: "1")

        do {
           
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
