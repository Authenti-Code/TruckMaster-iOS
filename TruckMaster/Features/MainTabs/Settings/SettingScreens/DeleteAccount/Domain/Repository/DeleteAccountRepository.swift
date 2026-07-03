//
//  DeletePasswordRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/07/26.
//

protocol DeleteAccountRepository {
    func deleteAccount(request: DeleteAccountRequestModel) async throws -> String
}
