//
//  HelpSupportViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class HelpSupportViewModel: ObservableObject {

    @Published var state = HelpSupportState()

    private let getMessagesUseCase: GetSupportMessagesUseCase
    private let sendMessageUseCase: SendSupportMessageUseCase
    private let router: AppRouter

    init(
        getMessagesUseCase: GetSupportMessagesUseCase,
        sendMessageUseCase: SendSupportMessageUseCase,
        router: AppRouter
    ) {
        self.getMessagesUseCase = getMessagesUseCase
        self.sendMessageUseCase = sendMessageUseCase
        self.router = router
    }

    func onAppear() {
        Task { await loadMessages() }
    }

    func backTapped() {
        router.navigateBack()
    }

    func sendTapped() {
        let trimmed = state.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        state.inputText = ""
        Task { await sendMessage(trimmed) }
    }

    private func loadMessages() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            state.messages = try await getMessagesUseCase.execute()
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func sendMessage(_ text: String) async {
        do {
            let message = try await sendMessageUseCase.execute(text: text)
            state.messages.append(message)
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
