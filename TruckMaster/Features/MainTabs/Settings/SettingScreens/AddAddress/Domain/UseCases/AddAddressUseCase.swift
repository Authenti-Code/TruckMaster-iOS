//
//  AddAddressUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

internal import Foundation

final class AddAddressUseCase {
    private let repository: AddAddressRepository
    
    init(repository: AddAddressRepository) {
        self.repository = repository
    }
    
    func execute(request: AddAddressRequest) async throws -> AddressData {
        return try await repository.addAddress(request: request)
    }
    func executeUpdateAddress(request: UpdateAddressRequest) async throws -> UpdateAddressResponseModel {
           try await repository.updateAddress(request: request)
       }
}
