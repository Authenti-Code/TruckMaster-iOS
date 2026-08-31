//
//  SupportRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

protocol SupportRepository {
    func fetchMessages(request: GetMsgRequest) async throws -> GetMsgResponse
    func sendMessage(text: String, ticketId: Int) async throws -> ChatMessageModel
}
