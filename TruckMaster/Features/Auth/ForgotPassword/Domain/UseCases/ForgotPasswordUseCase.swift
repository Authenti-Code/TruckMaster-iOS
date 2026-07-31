//
//  ForgotPasswordUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import Foundation

final class ForgotPasswordUseCase {

    private let repository: ForgotPasswordRepository

    init(repository: ForgotPasswordRepository) {
        self.repository = repository
    }

    func execute(request: ForgotPasswordRequestModel) async throws -> (ForgotPasswordResponseModel, String) {
        return try await repository.forgotPassword(request: request)
    }
}
