//
//  SignUpUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

import Foundation

final class SignUpUseCase {

    private let repository: SignUpRepository

    init(repository: SignUpRepository) {
        self.repository = repository
    }

    func execute(request: RegisterRequestModel) async throws -> UserModel {
        return try await repository.register(request: request)
    }
}
