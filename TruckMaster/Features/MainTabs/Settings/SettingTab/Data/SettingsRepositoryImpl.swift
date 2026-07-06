//
//  SettingsRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//


import Foundation

final class SettingsRepositoryImpl: SettingsRepository {
    func getUserProfileApi() async throws -> ProfileResponse {
  
            let response: ProfileResponse =
                try await apiClient.request(
                    endpoint: .profile,
                    method: .get,
                    body: nil as EmptyModel?
                )

            guard response.success == "true" else {
                throw NetworkError.apiError(
                    response.message.isEmpty
                        ? "Something went wrong. Please try again."
                        : response.message
                )
            }

            return response
        
    }
    
    func logout(request: LogoutRequestModel) async throws -> String? {
        let response: EmptyResponse =
            try await apiClient.request(
                endpoint: .logout,
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
    
    

    func getUserProfile() async throws -> UserModel? {
        UserPreferences.shared.getUser()
    }
}
