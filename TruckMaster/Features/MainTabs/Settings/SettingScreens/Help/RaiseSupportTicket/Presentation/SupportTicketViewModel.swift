//
//  SupportTicketViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class SupportTicketViewModel: ObservableObject {


    @Published var state = SupportTicketState()

    private let useCase: GetSupportTicketUseCase
    private let router: AppRouter

    init(useCase: GetSupportTicketUseCase, router: AppRouter) {
        self.useCase = useCase
        self.router  = router
    }

    func onAppear() {
        Task { await loadTickets() }
    }

    func refresh() async {
        await loadTickets()
    }

    func backTapped() {
        router.navigateBack()
    }

    func ticketTapped(_ ticket: SupportTicketModel) {
//        router.navigate(to: .ticketDetails(ticket: ticket))
    }

    func raiseTicketTapped() {
        state.showRaiseTicketSheet = true
    }

    func makeRaiseTicketViewModel() -> RaiseTicketViewModel? {
        RaiseTicketViewModel(router: router, useCase: useCase) { [weak self] in
            guard let self else { return }
            self.state.showRaiseTicketSheet = false
            Task { await self.loadTickets() }
        }
    }

    // MARK: - Private
    private func loadTickets() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.ticket = try await useCase.execute()
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
