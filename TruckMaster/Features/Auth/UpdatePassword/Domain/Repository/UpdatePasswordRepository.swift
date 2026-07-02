//
//  VerifyCodeRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

protocol UpdatePasswordRepository {
    func updatePassword(request: UpdatePasswordRequestModel) async throws -> String
}
