//
//  DeletePasswordUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/07/26.
//

final class DeleteAccountUseCase{
    private let repository: DeleteAccountRepository
    
    init(repository: DeleteAccountRepository){
        self.repository = repository
    }
    
    func execute(request: DeleteAccountRequestModel) async throws -> String {
        return try await repository.deleteAccount(request: request)
    }
}
