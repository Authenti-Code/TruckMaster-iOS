//
//  AddAddressRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

import Foundation

protocol AddAddressRepository {
    func addAddress(request: AddAddressRequest) async throws -> AddressData
    func updateAddress(request: UpdateAddressRequest) async throws -> UpdateAddressResponseModel
}
