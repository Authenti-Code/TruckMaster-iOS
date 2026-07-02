//
//  OrderDetailViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//


import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class OrderDetailViewModel: ObservableObject {

    @Published var state = OrderDetailState()
    private let useCase: OrderDetailUseCase
    private let router: AppRouter

    init(useCase: OrderDetailUseCase, router: AppRouter) {
        self.useCase = useCase
        self.router = router
    }

    func onAppear() {
        Task { await loadOrderDetail() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func rejectTapped() {
        // router.navigate(to: .rejectOrder) — wire when ready
    }

    func acceptTapped() {
        // router.navigate(to: .acceptOrder) — wire when ready
    }

    private func loadOrderDetail() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.order = try await useCase.execute()
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
