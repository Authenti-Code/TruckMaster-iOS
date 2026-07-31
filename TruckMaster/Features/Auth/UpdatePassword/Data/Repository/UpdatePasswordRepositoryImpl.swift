//
//  VerifyCodeRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

internal import Foundation

final class UpdatePasswordRepositoryImpl: UpdatePasswordRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
           self.apiClient = apiClient
       }

    func updatePassword(request: UpdatePasswordRequestModel) async throws -> String {
        let response: EmptyResponse =
            try await apiClient.request(
                endpoint: .updatePassword,
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
