//
//  LoginRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

import Foundation

struct LoginRequestModel: Codable {
    let email: String
    let password: String
    let deviceId: String
    let deviceToken: String
    let deviceType: String

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case deviceId     = "device_id"
        case deviceToken  = "device_token"
        case deviceType   = "device_type"
    }
}
