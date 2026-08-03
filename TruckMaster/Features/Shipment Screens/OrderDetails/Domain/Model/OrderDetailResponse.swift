//
//  OrderOfferDetailModel.swift
//  TruckMaster
//

internal import Foundation

// MARK: - Top-level response
struct OrderOfferDetailResponse: Codable {
    let success: String
    let message: String
    let data: OrderOfferDetail
}

// MARK: - Offer detail
struct OrderOfferDetail: Codable {
    let id: Int
    let pickupAddress: OrderAddress
    let dropAddress: OrderAddress
    let orderItems: [OrderItemDetail]
    let orderExtra: OrderExtras
    let company: OfferCompany
    let respondedAt: String?
    let status: String
    let price: String
    let priceBreakdown: OfferPriceBreakdown

    enum CodingKeys: String, CodingKey {
        case id
        case pickupAddress   = "pickup_address"
        case dropAddress     = "drop_address"
        case orderItems      = "order_items"
        case orderExtra      = "order_extra"
        case company
        case respondedAt     = "responded_at"
        case status
        case price
        case priceBreakdown  = "price_breakdown"
    }
}

// MARK: - Address
struct OrderAddress: Codable {
    let name: String?
    let address: String
    let contact: String?
    let latitude: Double
    let longitude: Double
}

// MARK: - Item
struct OrderItemDetail: Codable {
    let category: ItemCategory
    let subCategory: [ItemSubCategory]
    let dimensions: [ItemDimensionGroup]

    enum CodingKeys: String, CodingKey {
        case category
        case subCategory = "sub_category"
        case dimensions
    }
}

struct ItemCategory: Codable {
    let name: String
    let image: String?
    let quantity: Int
}

struct ItemSubCategory: Codable {
    let name: String
    let quantity: Int
}

struct ItemDimensionGroup: Codable {
    let label: String
    let unit: String
    let values: [OrderDimension]
}

struct OrderDimension: Codable {
    let width: String
    let length: String
}

// MARK: - Extras
struct OrderExtras: Codable {
    let helpers: Int
    let fragileHandling: Bool
    let stairsCarry: Bool
    let elevator: Bool
    let additionalInfo: String?
    let zipHandler: Bool

    enum CodingKeys: String, CodingKey {
        case helpers
        case fragileHandling = "fragile_handling"
        case stairsCarry     = "stairs_carry"
        case elevator
        case additionalInfo  = "additional_info"
        case zipHandler      = "zip_handler"
    }
}

// MARK: - Company
struct OfferCompany: Codable {
    let id: Int
    let companyName: String
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case logo
    }
}

// MARK: - Price breakdown
struct OfferPriceBreakdown: Codable {
    let taxCharges: Double
    let truckCharges: Double
    let helperCharges: Double

    enum CodingKeys: String, CodingKey {
        case taxCharges    = "tax_charges"
        case truckCharges  = "truck_charges"
        case helperCharges = "helper_charges"
    }
}


struct OrderOfferRespondData: Codable {
    let orderId: Int
    let companyId: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case orderId   = "order_id"
        case companyId = "company_id"
        case status
    }
}
