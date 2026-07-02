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

    func execute() async throws -> [ChatMessageModel] {
        try await repository.fetchMessages()
    }
}

final class SendSupportMessageUseCase {
    private let repository: SupportRepository

    init(repository: SupportRepository) {
        self.repository = repository
    }

    func execute(text: String) async throws -> ChatMessageModel {
        try await repository.sendMessage(text: text)
    }
}
