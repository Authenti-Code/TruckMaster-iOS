//
//  SignInUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//


final class SignInUseCase {

    private let repository: SignInRepository

    init(repository: SignInRepository) {
        self.repository = repository
    }

    func execute(request: LoginRequestModel) async throws -> UserModel {
        return try await repository.login(request: request)
    }
}

