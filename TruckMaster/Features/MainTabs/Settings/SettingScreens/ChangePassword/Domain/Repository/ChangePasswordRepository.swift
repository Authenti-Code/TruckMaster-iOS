//
//  AccountRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

protocol ChangePasswordRepository {
    func updatePassword(request: ChangePasswordRequest) async throws -> Bool
}
