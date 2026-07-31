//
//  SettingsRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

internal import Foundation

protocol SettingsRepository {
    func getUserProfile() async throws -> UserModel?
    func logout(request: LogoutRequestModel) async throws -> String?
    func getUserProfileApi() async throws -> ProfileResponse
}
