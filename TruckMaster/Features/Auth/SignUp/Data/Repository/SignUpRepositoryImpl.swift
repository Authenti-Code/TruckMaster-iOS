//
//  SignUpRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

//
//  SignUpRepositoryImpl.swift
//  TruckMaster
//

internal import Foundation


final class SignUpRepositoryImpl: SignUpRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func register(request: RegisterRequestModel) async throws -> UserModel {

        let response: BaseResponse<UserModel> =
            try await apiClient.request(
                endpoint: .register,
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

        return user
    }
}
