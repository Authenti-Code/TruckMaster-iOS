//
//  UpdatePasswordRequest.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct ChangePasswordRequest: Codable {
    let oldPassword: String
    let newPassword: String

    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }
}
