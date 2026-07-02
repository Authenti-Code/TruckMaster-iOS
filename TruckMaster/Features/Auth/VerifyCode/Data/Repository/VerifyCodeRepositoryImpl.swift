//
//  VerifyCodeRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

import Foundation

final class VerifyCodeRepositoryImpl: VerifyCodeRepository {
    func resendCode(request: ResendCodeRequestModel) async throws -> String {
        let response: EmptyResponse =
            try await apiClient.request(
                endpoint: .resendOtp,
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
    

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
           self.apiClient = apiClient
       }

    func verifyCode(request: VerifyCodeRequestModel) async throws -> String {
        let response: EmptyResponse =
            try await apiClient.request(
                endpoint: .verifyOtp,
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
