//
//  GetUserProfileUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

internal import Foundation

final class GetUserProfileUseCase {

    private let repository: SettingsRepository

    init(repository: SettingsRepository) {
        self.repository = repository
    }

    func execute() async throws -> UserModel? {
        try await repository.getUserProfile()
    }
    

    
    func logoutExecute(request: LogoutRequestModel) async throws -> String {
        return try await repository.logout(request: request) ?? ""
    }
    
    func executeGetProfile() async throws -> ProfileResponse {
        try await repository.getUserProfileApi()
    }
}
