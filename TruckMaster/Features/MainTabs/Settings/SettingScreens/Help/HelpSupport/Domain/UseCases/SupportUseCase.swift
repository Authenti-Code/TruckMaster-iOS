//
//  SupportUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

final class GetSupportMessagesUseCase {
    private let repository: SupportRepository

    init(repository: SupportRepository) {
        self.repository = repository
    }

    func execute(request: GetMsgRequest) async throws -> GetMsgResponse {
        try await repository.fetchMessages(request: request)
    }
}

final class SendSupportMessageUseCase {
    private let repository: SupportRepository

    init(repository: SupportRepository) {
        self.repository = repository
    }

    func execute(text: String, ticketId: Int) async throws -> ChatMessageModel {
        try await repository.sendMessage(text: text, ticketId: ticketId)
    }
}
