//
//  EditProfileRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//
import Foundation

struct EditProfileRequestModel: Codable {
    let name:    String
    let email:   String
    let contact: String
    let profileImg: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case contact = "phone_number"
        case profileImg = "profile_image"
    }
}
