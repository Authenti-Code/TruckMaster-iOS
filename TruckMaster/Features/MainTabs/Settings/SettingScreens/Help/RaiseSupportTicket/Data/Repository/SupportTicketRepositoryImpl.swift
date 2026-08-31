//
//  SupportTicketRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

final class SupportTicketRepositoryImpl: SupportTicketRepository {
    
    
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchTickets() async throws -> [SupportTicketModel] {
        let response: BaseResponse<SupportTicketResponseModel> =
            try await apiClient.request(
                endpoint: .getSupportTickets,
                method: .post,
                body: nil as EmptyModel?
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        return response.data?.tickets ?? []
    }
    
    func raiseTicket(request: RaiseTicketRequestModel) async throws -> RaiseTicketResponseModel {
        let response: BaseResponse<RaiseTicketResponseModel> =
            try await apiClient.request(
                endpoint: .raiseTicket,
                method: .post,
                body: request
            )

        guard response.success == "true", let data = response.data else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        return data
    }

}
