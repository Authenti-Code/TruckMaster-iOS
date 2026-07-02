//
//  UpdateAddressRequest.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct UpdateAddressRequest: Codable {
    let address: String
    let subAddress: String
    let name: String
    let latitude: String
    let longitude: String
    let phoneNumber: String
    let label: String
    let addressId: String

    enum CodingKeys: String, CodingKey {
        case address
        case name
        case latitude
        case longitude
        case phoneNumber = "phone_number"
        case subAddress = "formatted_address"
        case label
        case addressId = "address_id"
    }
}
