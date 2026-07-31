//
//  OrderModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

internal import Foundation

// MARK: - Response

struct OrderListData: Codable {
    let orders: [OrderResponse]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case orders
        case totalPages
    }
}

struct OrderResponse: Codable, Identifiable {
    let id: Int
    let status: String
    let pickupAddress: OrderLocationAddress
    let dropAddress: OrderLocationAddress

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case pickupAddress = "pickup_address"
        case dropAddress = "drop_address"
    }
}

struct OrderLocationAddress: Codable {
    let name: String
    let address: String
    let contact: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Request
struct OrderListRequest: Codable {
    let page: String
    let limit: String
    let status: String
}
