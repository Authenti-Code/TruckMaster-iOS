//
//  SignUpRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import Foundation

protocol SignUpRepository {
    func register(request: RegisterRequestModel) async throws -> UserModel
}
