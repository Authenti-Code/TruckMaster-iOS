//
//  SupportRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


import Foundation

protocol GetAutoReplyUseCase {
    func execute() async throws -> ChatMessageModel
}

final class SupportRepositoryImpl: SupportRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }


    
    func fetchMessages() async throws -> [ChatMessageModel] {
        // TODO: replace with real endpoint once available
        try await Task.sleep(nanoseconds: 500_000_000)

        return [
            ChatMessageModel(id: 1, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", isFromUser: false),
            ChatMessageModel(id: 2, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", isFromUser: true),
            ChatMessageModel(id: 3, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", isFromUser: false),
            ChatMessageModel(id: 4, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit", isFromUser: true)
        ]
    }

    func sendMessage(text: String) async throws -> ChatMessageModel {
        // TODO: replace with real endpoint once available
        try await Task.sleep(nanoseconds: 300_000_000)

        return ChatMessageModel(
            id: Int(Date().timeIntervalSince1970 * 1000),
            text: text,
            isFromUser: true
        )
    }
    
}
