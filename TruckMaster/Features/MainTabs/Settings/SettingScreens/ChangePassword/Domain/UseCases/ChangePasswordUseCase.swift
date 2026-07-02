//
//  UpdatePasswordUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

final class ChangePasswordUseCase {
    private let repository: ChangePasswordRepository

    init(repository: ChangePasswordRepository) {
        self.repository = repository
    }

    func execute(request: ChangePasswordRequest) async throws -> Bool {
        try await repository.updatePassword(request: request)
    }
}
