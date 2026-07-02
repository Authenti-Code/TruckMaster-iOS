//
//  GetSavedAddressesUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

final class GetSavedAddressesUseCase {
    private let repository: SavedAddressRepository

    init(repository: SavedAddressRepository) {
        self.repository = repository
    }

    func execute() async throws -> [SavedAddressModel] {
        try await repository.fetchAddresses()
    }
    
    func executeDeleteAddress(id: Int) async throws -> Bool {
         try await repository.deleteAddress(id: id)
     }
}
