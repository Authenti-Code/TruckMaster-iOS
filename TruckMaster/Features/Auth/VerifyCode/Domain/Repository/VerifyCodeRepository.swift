//
//  VerifyCodeRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

protocol VerifyCodeRepository {
    func verifyCode(request: VerifyCodeRequestModel) async throws -> String
    func resendCode(request: ResendCodeRequestModel) async throws -> String
}
