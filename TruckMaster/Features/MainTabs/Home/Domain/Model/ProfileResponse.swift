//
//  ProfileResponse.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//
internal import Foundation

struct ProfileResponse: Codable {
    let success: String
    let message: String
    let data: ProfileData?
}

struct ProfileData: Codable {
    let id: String?
    let name: String?
    let email: String?
    let phoneNumber: String?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phoneNumber = "phone_number"
        case profileImage = "profile_image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = "\(intId)"
        } else {
            id = try? container.decode(String.self, forKey: .id)
        }

        name = try? container.decode(String.self, forKey: .name)
        email = try? container.decode(String.self, forKey: .email)
        phoneNumber = try? container.decode(String.self, forKey: .phoneNumber)
        profileImage = try? container.decode(String.self, forKey: .profileImage)
    }
}
