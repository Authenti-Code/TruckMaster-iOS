//
//  ForgotPasswordUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//


internal import Foundation

final class VerifyCodeUseCase {

    private let repository: VerifyCodeRepository

    init(repository: VerifyCodeRepository) {
        self.repository = repository
    }

    func execute(request: VerifyCodeRequestModel) async throws -> String {
        return try await repository.verifyCode(request: request)
    }
    
    func executeResendCode(request: ResendCodeRequestModel) async throws -> String {
        return try await repository.resendCode(request: request)
    }
}
