//
//  ForgotPasswordUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//


internal import Foundation

final class UpdatePasswordUseCase {

    private let repository: UpdatePasswordRepository

    init(repository: UpdatePasswordRepository) {
        self.repository = repository
    }

    func execute(request: UpdatePasswordRequestModel) async throws -> String {
        return try await repository.updatePassword(request: request)
    }
}
