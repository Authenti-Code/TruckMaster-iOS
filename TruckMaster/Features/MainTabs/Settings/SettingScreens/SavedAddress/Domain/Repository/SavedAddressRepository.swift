//
//  SavedAddressRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

protocol SavedAddressRepository {
    func fetchAddresses() async throws -> [SavedAddressModel]
    func deleteAddress(id: Int) async throws -> Bool
    
}
