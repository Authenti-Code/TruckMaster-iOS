//
//  HelpSupportViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

internal import Foundation
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class HelpSupportViewModel: ObservableObject {

    @Published var state = HelpSupportState()

    private let getMessagesUseCase: GetSupportMessagesUseCase
    private let sendMessageUseCase: SendSupportMessageUseCase
    private let messageReceiver: MessageReceiveProtocol
    private var listenTask: Task<Void, Never>?
    private let router: AppRouter
    private let ticketId: Int
    private let pageLimit = 10

    init(
        getMessagesUseCase: GetSupportMessagesUseCase,
        sendMessageUseCase: SendSupportMessageUseCase,
        messageReceiver: MessageReceiveProtocol,
        router: AppRouter,
        ticketId: Int
    ) {
        self.getMessagesUseCase = getMessagesUseCase
        self.sendMessageUseCase = sendMessageUseCase
        self.messageReceiver = messageReceiver
        self.router = router
        self.ticketId = ticketId
    }

    func onAppear() {
        Task { await loadMessages() }
        startListening()
    }

    func onDisappear() {
        stopListening()
    }

    func backTapped() {
        stopListening()
        router.navigateBack()
    }

    func sendTapped() {
        let trimmed = state.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        state.inputText = ""
        Task { await sendMessage(trimmed) }
    }

    func loadMoreIfNeeded(currentMessage message: ChatMessageModel) {
        guard message.id == state.messages.first?.id else { return }
        guard state.hasMore, !state.isLoadingMore, !state.isLoading else { return }
        Task { await loadMessages(page: state.currentPage + 1, append: true) }
    }

    private func loadMessages(page: Int = 1, append: Bool = false) async {
        if append {
            state.isLoadingMore = true
        } else {
            state.isLoading = true
        }
        defer {
            if append {
                state.isLoadingMore = false
            } else {
                state.isLoading = false
            }
        }

        do {
            let request = GetMsgRequest(id: ticketId, page: page, limit: pageLimit)
            let response = try await getMessagesUseCase.execute(request: request)
            let mapped = response.messages.map { $0.toChatMessageModel() }

            if append {
                state.messages = mapped + state.messages
            } else {
                state.messages = mapped
            }

            state.currentPage = response.pagination.page ?? page
            state.hasMore = response.pagination.hasMore ?? false
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func sendMessage(_ text: String) async {
        do {
            let message = try await sendMessageUseCase.execute(text: text, ticketId: ticketId)
            appendIfNew(message)
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func startListening() {
        
        messageReceiver.startListening(resource: "ticket", resourceId: String(ticketId))

        listenTask = Task { [weak self] in
            guard let self else { return }
            for await incoming in self.messageReceiver.onMessageReceived() {
                let mapped = incoming.toChatMessageModel()
                self.appendIfNew(mapped)
            }
        }
    }

    private func stopListening() {
        listenTask?.cancel()
        listenTask = nil
        messageReceiver.stopListening()
    }

    private func appendIfNew(_ message: ChatMessageModel) {
        guard !state.messages.contains(where: { $0.id == message.id }) else { return }
        state.messages.append(message)
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }
}
