//
//  ForgotPasswordRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//


internal import Foundation

final class ForgotPasswordRepositoryImpl: ForgotPasswordRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func forgotPassword(request: ForgotPasswordRequestModel) async throws -> (ForgotPasswordResponseModel, String) {
        let response: BaseResponse<ForgotPasswordResponseModel> =
            try await apiClient.request(
                endpoint: .forgotPassword,
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
            throw NetworkError.noData
        }

        return (data, response.message)
    }
}
