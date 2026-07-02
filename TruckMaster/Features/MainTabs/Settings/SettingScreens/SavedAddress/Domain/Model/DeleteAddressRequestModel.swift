//
//  DeleteAddressRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct DeleteAddressRequestModel: Codable, Identifiable {
    let id: Int
 
    enum CodingKeys: String, CodingKey {
        case id = "address_id"
    }
}

struct DeleteAddressResponseModel: Codable {
    let id: Int
}
