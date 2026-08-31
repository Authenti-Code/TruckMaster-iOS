//
//  SupportModels.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct GetMsgRequest: Codable {
    let id: Int?
    let page: Int?
    let limit: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ticket_id"
        case page
        case limit
    }
}

struct GetMsgResponse: Codable {
    let messages: [Messages]
    let pagination: GetMsgPagination
}

struct Messages: Codable {
    let id: Int?
    let senderType: String?
    let senderId: Int?
    let message: String?
    let isRead: Bool?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case senderType = "sender_type"
        case senderId = "sender_id"
        case message
        case isRead = "is_read"
        case createdAt
    }
}

struct GetMsgPagination: Codable {
    let page: Int?
    let total: Int?
    let totalPages: Int?
    let hasMore: Bool?
}

extension Messages {
    func toChatMessageModel() -> ChatMessageModel {
        ChatMessageModel(
            id: id ?? 0,
            text: message ?? "",
            isFromUser: senderType == "customer"
        )
    }
}



struct SendMsgRequest: Codable {
    let ticketId: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case ticketId = "ticket_id"
        case message
    }
}
