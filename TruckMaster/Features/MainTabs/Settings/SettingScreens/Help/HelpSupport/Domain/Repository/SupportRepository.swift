//
//  SupportRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

protocol SupportRepository {
    func fetchMessages() async throws -> [ChatMessageModel]
    func sendMessage(text: String) async throws -> ChatMessageModel
}
