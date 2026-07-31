//
//  RegisterRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//


internal import Foundation

struct RegisterRequestModel: Codable {
    let name: String
    let email: String
    let phoneNumber: String
    let password: String
    let confirmPassword: String
    let isAgreed: String
    let deviceId: String
    let deviceToken: String
    let deviceType: String

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phoneNumber  = "phone_number"
        case password
        case confirmPassword = "confirm_password"
        case isAgreed = "terms_condition"
        case deviceId     = "device_id"
        case deviceToken  = "device_token"
        case deviceType   = "device_type"
    }
}
