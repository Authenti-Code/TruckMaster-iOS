//
//  AddAddressRequest.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

struct AddAddressRequest: Codable {
    let address: String
    let subAddress: String
    let name: String
    let phoneNumber: String
    let label: String
    let latitude: String
    let longitude: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case name
        case phoneNumber = "phone_number"
        case subAddress = "formatted_address"
        case label
        case latitude
        case longitude
    }
}
