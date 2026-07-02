    //
//  VerifyCodeRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

struct ResendCodeRequestModel: Codable{
    let resetToken : String
    
    enum CodingKeys: String, CodingKey {
        case resetToken = "reset_token"
    }
}
