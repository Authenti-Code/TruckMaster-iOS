//
//  DeleteAccountRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/07/26.
//

final class DeleteAccountRepositoryImpl : DeleteAccountRepository {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func deleteAccount(request: DeleteAccountRequestModel) async throws -> String {
        let response: EmptyResponse =
            try await apiClient.request(
                endpoint: .deleteAccount,
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

        return response.message
    }
    
    
}
