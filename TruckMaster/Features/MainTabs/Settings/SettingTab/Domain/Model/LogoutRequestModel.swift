//
//  LogoutRequestModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

struct LogoutRequestModel: Codable{
    let deviceId : String
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
    }
}
