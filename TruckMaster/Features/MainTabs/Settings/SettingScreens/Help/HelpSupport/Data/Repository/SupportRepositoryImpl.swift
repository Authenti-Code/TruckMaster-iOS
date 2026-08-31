//
//  SupportRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

internal import Foundation

protocol GetAutoReplyUseCase {
    func execute() async throws -> ChatMessageModel
}

final class SupportRepositoryImpl: SupportRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchMessages(request: GetMsgRequest) async throws -> GetMsgResponse {
        let response: BaseResponse<GetMsgResponse> =
        try await apiClient.request(
            endpoint: .getMessages,
            method: .post,
            body: request
        )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        guard let data = response.data else {
            throw NetworkError.apiError("No data returned.")
        }

        return data
    }

    func sendMessage(text: String, ticketId: Int) async throws -> ChatMessageModel {
        let request = SendMsgRequest(ticketId: ticketId, message: text)

        let response: BaseResponse<Messages> =
        try await apiClient.request(
            endpoint: .sendSupportMessage,
            method: .post,
            body: request
        )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        guard let data = response.data else {
            throw NetworkError.apiError("No data returned.")
        }

        return data.toChatMessageModel()
    }
}
