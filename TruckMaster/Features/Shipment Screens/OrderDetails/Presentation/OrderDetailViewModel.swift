//
//  OrderDetailViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class OrderDetailViewModel: ObservableObject {

    @Published var state = OrderDetailState()
    private let useCase: OrderDetailUseCase
    private let router: AppRouter
    private let orderId: String
    private let companyId: Int

    init(useCase: OrderDetailUseCase, router: AppRouter, orderId: String, companyId: Int) {
        self.useCase = useCase
        self.router = router
        self.orderId = orderId
        self.companyId = companyId
    }

    func onAppear() {
        Task { await loadOrderDetail() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func rejectTapped() {
        Task { await respond(status: "decline") }
    }

    func acceptTapped() {
        Task { await respond(status: "accept") }
    }

    private func loadOrderDetail() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.order = try await useCase.execute(orderId: orderId, companyId: companyId)
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func respond(status: String) async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            let result = try await useCase.respond(
                status: status,
                orderId: orderId,
                companyId: String(companyId)
            )
            triggerSuccess(
                result.status.lowercased() == "declined"
                    ? "Offer declined successfully"
                    : "Offer accepted successfully"
            )
            router.navigateBack()
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }

    private func triggerSuccess(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .success
        state.showSnackbar    = true
    }
}
