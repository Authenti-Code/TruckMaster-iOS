//
//  NotificationViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//



internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class NotificationViewModel: ObservableObject {

    @Published var state = NotificationState()

    private let getNotificationsUseCase: GetNotificationsUseCase
    private let router: AppRouter

    init(getNotificationsUseCase: GetNotificationsUseCase, router: AppRouter) {
        self.getNotificationsUseCase = getNotificationsUseCase
        self.router = router
    }

    func onAppear() {
        Task { await loadNotifications() }
    }

    func onRefresh() async {
        await loadNotifications()
    }

    func backTapped() {
        router.navigateBack()
    }

    private func loadNotifications() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.notifications = try await getNotificationsUseCase.execute()
        } catch {
//            triggerError(error.localizedDescription)
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
