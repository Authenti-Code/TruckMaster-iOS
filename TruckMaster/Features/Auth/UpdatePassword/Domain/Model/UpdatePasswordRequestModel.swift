//
//  UpdatePasswordRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 10/06/26.
//

struct UpdatePasswordRequestModel: Codable{
    let resetToken: String
    let password: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case resetToken = "reset_token"
        case password
        case confirmPassword = "confirm_password"
    }
}
