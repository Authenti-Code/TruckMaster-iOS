//
//  AddAddressResponse.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

struct AddAddressResponse: Codable {
    let data: AddressData
}

struct AddressData: Codable {
    let isDefault: Bool
    let id: Int
    let address: String
    let latitude: String
    let longitude: String
    let phoneNumber: String
    let name: String
    let label: String
    let userId: Int
    let updatedAt: String
    let createdAt: String
    let landmark: String?
    let formattedAddress: String?
    let city: String?
    let state: String?
    let country: String?
    let postalCode: String?
    let meta: String?

    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case id
        case address
        case latitude
        case longitude
        case phoneNumber = "phone_number"
        case formattedAddress = "formatted_address"
        case name
        case label
        case userId = "user_id"
        case updatedAt
        case createdAt
        case landmark
        case city
        case state
        case country
        case postalCode = "postal_code"
        case meta
    }
}
