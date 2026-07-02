//
//  VerifyCodeRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

struct VerifyCodeRequestModel: Codable{
    let resetToken : String
    let otp : String
    
    enum CodingKeys: String, CodingKey {
        case resetToken = "reset_token"
        case otp
    }
}
