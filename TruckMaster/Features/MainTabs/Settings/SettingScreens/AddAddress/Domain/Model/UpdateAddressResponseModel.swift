//
//  UpdateAddressResponseModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct UpdateAddressResponseModel: Codable {
    let id: Int
    let address: String
    let name: String
    let label: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case id, address, name, label
        case phoneNumber = "phone_number"
    }
}
