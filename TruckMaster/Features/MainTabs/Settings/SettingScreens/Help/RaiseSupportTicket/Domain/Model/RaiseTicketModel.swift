//
//  RaiseTicketModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 31/08/26.
//

struct RaiseTicketRequestModel: Codable, Hashable {
    let subject: String
    let description: String
}

struct RaiseTicketResponseModel: Codable {
    let id: Int
}
