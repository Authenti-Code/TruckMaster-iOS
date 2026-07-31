//
//  ActiveOrderModels.swift
//  TruckMaster
//

internal import Foundation

struct ActiveOrderData: Codable {
    let hasActiveOrder: Bool
    let order: ActiveOrder?
    let offers: [ActiveOrderOffer]

    enum CodingKeys: String, CodingKey {
        case hasActiveOrder = "has_active_order"
        case order
        case offers
    }
}

struct ActiveOrder: Codable {
    let id: Int
    let pickupAddress: PickupAddressInfo
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case pickupAddress = "pickup_address"
        case status
    }
}

struct PickupAddressInfo: Codable {
    let name: String
    let address: String
    let contact: String
    let latitude: Double
    let longitude: Double
}

struct ActiveOrderOffer: Codable{
    let price: String?
    let respondedAt: String?
    let expiresAt: String?
    let company: ActiveOrderCompany

    enum CodingKeys: String, CodingKey {
        case price
        case respondedAt = "responded_at"
        case expiresAt = "expires_at"
        case company
    }
}

struct ActiveOrderCompany: Codable {
    let logo: String?
    let id: Int
    let companyName: String

    enum CodingKeys: String, CodingKey {
        case logo
        case id
        case companyName = "company_name"
    }
}
