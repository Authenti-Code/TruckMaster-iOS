//
//  ForgotPasswordResponseModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//


internal import Foundation

struct ForgotPasswordResponseModel: Codable {
    let resetToken: String

    enum CodingKeys: String, CodingKey {
        case resetToken = "reset_token"
    }
}
