//
//  SizesViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

internal import Foundation
internal import Combine
import SwiftUI
@available(iOS 16.0, *)
@MainActor
final class RaiseTicketViewModel: ObservableObject {

    @Published var state = RaiseTicketState()

    private let router: AppRouter
    private let useCase: GetSupportTicketUseCase
    private let onSuccess: () -> Void

    init(router: AppRouter, useCase: GetSupportTicketUseCase, onSuccess: @escaping () -> Void) {
        self.router = router
        self.useCase = useCase
        self.onSuccess = onSuccess
    }
    
    var titleBinding: Binding<String> {
        Binding(
            get: { self.state.title },
            set: { self.handleTitleChange($0) }
        )
    }

    var descriptionBinding: Binding<String> {
        Binding(
            get: { self.state.description },
            set: { newValue in
                guard !newValue.hasPrefix(" ") else { return }
                self.state.description = newValue
            }
        )
    }

    private func handleTitleChange(_ newValue: String) {
        guard !newValue.hasPrefix(" ") else { return }
        state.title = newValue
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
    
    func submitTapped() -> Bool {
        guard !state.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            triggerError("Title is required")
            return false
        }
        guard !state.description.trimmingCharacters(in: .whitespaces).isEmpty else {
            triggerError("Description is required")
            return false
        }

        Task { await raiseTicket() }
        return true
    }
    
    private func raiseTicket() async {
        state.isLoading = true
        defer { state.isLoading = false }

        let request = RaiseTicketRequestModel(
            subject: state.title,
            description: state.description
        )

        do {
            _ = try await useCase.raiseTicket(request: request)
            onSuccess()
        } catch {
            triggerError(error.localizedDescription)
        }
    }
}
