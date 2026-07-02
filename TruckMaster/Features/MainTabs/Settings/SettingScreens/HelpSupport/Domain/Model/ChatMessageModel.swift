//
//  ChatMessageModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

struct ChatMessageModel: Codable, Identifiable, Hashable {
    let id: Int
    let text: String
    let isFromUser: Bool
}
