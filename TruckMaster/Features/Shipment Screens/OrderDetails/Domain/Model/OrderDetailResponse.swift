//
//  OrderDetailModel.swift
//  TruckMaster
//

internal import Foundation

// MARK: - Order Detail Response
struct OrderDetailResponse: Codable {
    let orderId: String
    let status: String
    let pickupAddress: OrderAddress
    let dropAddress: OrderAddress
    let items: [OrderItem]
    let extras: OrderExtras
    let scheduleType: String
    let scheduledAt: String?
    let companyOffer: CompanyOffer?
    let priceBreakdown: PriceBreakdown?

    enum CodingKeys: String, CodingKey {
        case orderId       = "order_id"
        case status
        case pickupAddress = "pickup_address"
        case dropAddress   = "drop_address"
        case items
        case extras
        case scheduleType  = "schedule_type"
        case scheduledAt   = "scheduled_at"
        case companyOffer  = "company_offer"
        case priceBreakdown = "price_breakdown"
    }
}

// MARK: - Address
struct OrderAddress: Codable {
    let address: String
    let latitude: String
    let longitude: String
    let name: String?
    let contact: String?
}

// MARK: - Item
struct OrderItem: Codable {
    let categoryId: String
    let categoryName: String?
    let categoryImage: String?
    let subCategoryId: Int?
    let quantity: Int?
    let dimensions: [OrderDimension]
    let dimensionUnit: String?

    enum CodingKeys: String, CodingKey {
        case categoryId    = "category_id"
        case categoryName  = "category_name"
        case categoryImage = "category_image"
        case subCategoryId = "sub_category_id"
        case quantity
        case dimensions
        case dimensionUnit = "dimension_unit"
    }
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
    let urgent: Bool
    let zipHandler: Bool
    let elevator: Bool
    let additionalInfo: String?

    enum CodingKeys: String, CodingKey {
        case helpers
        case fragileHandling  = "fragile_handling"
        case stairsCarry      = "stairs_carry"
        case urgent
        case zipHandler       = "zip_handler"
        case elevator
        case additionalInfo   = "additional_info"
    }
}


struct CompanyOffer: Codable {
    let companyId: String
    let companyName: String
    let companyImage: String?
    let rating: String?
    let truckType: String?
    let estimatedTime: String?
    let totalPrice: Double

    enum CodingKeys: String, CodingKey {
        case companyId    = "company_id"
        case companyName  = "company_name"
        case companyImage = "company_image"
        case rating
        case truckType    = "truck_type"
        case estimatedTime = "estimated_time"
        case totalPrice   = "total_price"
    }
}

// MARK: - Price Breakdown (matches screenshot's "Price Breakup" section)
struct PriceBreakdown: Codable {
    let distanceLabel: String?     
    let distancePrice: Double
    let helpersPrice: Double
    let tax: Double
    let total: Double

    enum CodingKeys: String, CodingKey {
        case distanceLabel  = "distance_label"
        case distancePrice  = "distance_price"
        case helpersPrice   = "helpers_price"
        case tax
        case total
    }
}
