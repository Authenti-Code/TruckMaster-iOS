//
//  OrdersViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation
internal import Combine


// MARK: - ViewModel
@available(iOS 16.0, *)
@MainActor
final class OrdersViewModel: ObservableObject {

    @Published var state = OrderState()

    private let getOrdersUseCase: GetOrdersUseCase
    private let router: AppRouter

    init(
        getOrdersUseCase: GetOrdersUseCase,
        router: AppRouter
    ) {
        self.getOrdersUseCase = getOrdersUseCase
        self.router           = router
    }

    // MARK: - Lifecycle
    func onAppear() {
        Task { await loadOrders(isRefresh: false) }
    }

    func onRefresh() async {
        await loadOrders(isRefresh: true)
    }

    func onLoadMore() async {
        guard !state.isLoadingMore, state.hasMoreData else { return }
        await loadOrders(isRefresh: false, isLoadMore: true)
    }

    // MARK: - Actions
    func notificationTapped() {
         router.navigate(to: .notifications)
    }

    // MARK: - Private
    private func loadOrders(isRefresh: Bool, isLoadMore: Bool = false) async {
        if isRefresh {
            state.isRefreshing = true
            state.currentPage  = 1
        } else if isLoadMore {
            state.isLoadingMore = true
        } else {
            state.isLoading = true
        }
        defer {
            state.isLoading     = false
            state.isRefreshing  = false
            state.isLoadingMore = false
        }
        do {
            let data = try await getOrdersUseCase.execute(page: state.currentPage)

            if isRefresh {
                state.orders = data
            } else {
                state.orders += data
            }

            state.hasMoreData = !data.isEmpty
            if !data.isEmpty { state.currentPage += 1 }
            state.snackbarMessage = ""
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
