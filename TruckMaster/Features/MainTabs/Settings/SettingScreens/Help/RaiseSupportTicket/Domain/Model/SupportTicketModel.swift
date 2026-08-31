//
//  SavedAddressModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//


struct TicketOrderModel: Codable, Hashable {
    let id: Int
}

struct SupportTicketModel: Codable, Identifiable, Hashable {
    let id: Int
    let subject: String
    let status: String
    let order_id: Int?
    let description: String?
    let createdAt: String
    let order: TicketOrderModel?
}

struct SupportTicketResponseModel: Codable {
    let tickets: [SupportTicketModel]
    let totalPages: Int
}
