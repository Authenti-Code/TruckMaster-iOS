//
//  EditProfileResponse.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//
import Foundation

struct EditProfileResponse: Codable {
    let success: String
    let message: String
    let data:    UserModel?
}
