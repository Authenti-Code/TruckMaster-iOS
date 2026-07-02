//
//  EnRouteViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//
import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class EnRouteViewModel: ObservableObject {
    @Published var state = EnRouteState()

    private let useCase: EnRouteUseCase
    private let router: AppRouter

    init(useCase: EnRouteUseCase, router: AppRouter) {
        self.useCase = useCase
        self.router = router
    }

    func onAppear() {
        Task { await loadOrders() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func tabChanged(_ tab: EnRouteTab) {
        state.selectedTab = tab
    }

    func orderTapped(_ order: ShipmentModel) {
        // router.navigate(to: .orderDetail) — wire when ready
        router.navigate(to: .mapTrack)
    }

    private func loadOrders() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.orders = try await useCase.execute()
        } catch {
            state.snackbarMessage = error.localizedDescription
            state.snackbarType = .error
            state.showSnackbar = true
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
