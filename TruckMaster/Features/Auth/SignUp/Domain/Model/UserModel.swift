//
//  UserModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

import Foundation

struct UserModel: Codable {
    let id:    String?
    let token: String
    let name: String
    let email: String
    let phoneNumber: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case token
        case name
        case email
        case phoneNumber  = "phone_number"
        case profileImage = "profile_image"
    }
}
