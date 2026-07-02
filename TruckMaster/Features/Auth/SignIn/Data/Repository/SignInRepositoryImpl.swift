//
//  SignInRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

import Foundation
final class SignInRepositoryImpl: SignInRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func login(request: LoginRequestModel) async throws -> UserModel {

        let response: BaseResponse<UserModel> =
            try await apiClient.request(
                endpoint: .login,
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

        guard let user = response.data else {
            throw NetworkError.noData
        }
        UserPreferences.shared.saveUser(user)
        return user
    }
}
