//
//  ChangePasswordRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


final class ChangePasswordRepositoryImpl: ChangePasswordRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func updatePassword(request: ChangePasswordRequest) async throws -> Bool {
        let response: BaseResponse<EmptyModel> =
            try await apiClient.request(
                endpoint: .changePassword,
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

        return true
    }
}
