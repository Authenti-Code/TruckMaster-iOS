//
//  SavedAddressModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//


struct SavedAddressModel: Codable, Identifiable, Hashable {
    let id: Int
    let address: String
    let name: String
    let phoneNumber: String?
    let label: String
    let latitude: String
    let longitude: String
    let subAddress: String

    enum CodingKeys: String, CodingKey {
        case id, address, name, label, latitude, longitude
        case phoneNumber = "phone_number"
        case subAddress = "formatted_address"
    }
}

struct SavedAddressResponseModel: Codable {
    let addresses: [SavedAddressModel]
    let totalPages: Int
}
