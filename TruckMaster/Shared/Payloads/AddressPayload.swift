//
//  ShipmentDraft.swift
//  TruckMaster
//
//  Created by AuthentiCode on 19/06/26.
//

import Foundation

// MARK: - AddressPayload
struct AddressPayload: Encodable {
    var address: String
    var latitude: String
    var longitude: String
    var name: String?
    var contact: String?
    var label: String?
    var landmark: String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?

    enum CodingKeys: String, CodingKey {
        case address, latitude, longitude, name, contact, label, landmark, city, state, country
        case postalCode = "postal_code"
    }
}

struct DimensionRequest: Encodable {
    let width: String
    let length: String
}

struct ItemRequest: Encodable {
    let categoryId: String
    let subCategoryId: Int?
    var quantity: Int?
    var dimensions: [DimensionRequest]
    let dimensionUnit: String?

    enum CodingKeys: String, CodingKey {
        case categoryId    = "category_id"
        case subCategoryId = "sub_category_id"
        case quantity
        case dimensions
        case dimensionUnit = "dimension_unit"
    }
}


struct ExtrasRequest: Encodable {
    var helpers: Int = 0
    var fragileHandling: Bool = false
    var stairsCarry: Bool = false
    var urgent: Bool = false
    var zipHandler: Bool = false
    var elevator: Bool = false
    var additionalInfo: String? = nil

    enum CodingKeys: String, CodingKey {
        case helpers
        case fragileHandling = "fragile_handling"
        case stairsCarry = "stairs_carry"
        case urgent
        case zipHandler = "zip_handler"
        case elevator
        case additionalInfo = "additional_info"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(helpers, forKey: .helpers)
        try container.encode(fragileHandling, forKey: .fragileHandling)
        try container.encode(stairsCarry, forKey: .stairsCarry)
        try container.encode(urgent, forKey: .urgent)
        try container.encode(zipHandler, forKey: .zipHandler)
        try container.encode(elevator, forKey: .elevator)
        try container.encode(additionalInfo, forKey: .additionalInfo)
    }
}

struct CreateShipmentRequest: Encodable {
    let pickupAddress: AddressPayload
    let dropAddress: AddressPayload
    let items: [ItemRequest]
    let extras: ExtrasRequest
    let scheduleType: String
    let scheduledAt: String?

    enum CodingKeys: String, CodingKey {
        case pickupAddress = "pickup_address"
        case dropAddress   = "drop_address"
        case items, extras
        case scheduleType  = "schedule_type"
        case scheduledAt   = "scheduled_at"
    }
}


final class ShipmentDraft: CustomStringConvertible {
    var pickup: AddressPayload?
    var dropoff: AddressPayload?
    var items: [ItemRequest] = []
    var extras: ExtrasRequest = ExtrasRequest()
    var scheduleType: String = "instant"
    var scheduledAt: String? = nil

    var description: String {
        """
        ShipmentDraft(
          pickup: \(String(describing: pickup)),
          dropoff: \(String(describing: dropoff)),
          items: \(items),
          extras: \(extras),
          scheduleType: \(scheduleType),
          scheduledAt: \(String(describing: scheduledAt))
        )
        """
    }

    func buildRequest() -> CreateShipmentRequest? {
        guard let pickup, let dropoff, !items.isEmpty else { return nil }
        return CreateShipmentRequest(
            pickupAddress: pickup,
            dropAddress: dropoff,
            items: items,
            extras: extras,
            scheduleType: scheduleType,
            scheduledAt: scheduledAt
        )
    }

    func reset() {
        pickup = nil
        dropoff = nil
        items = []
        extras = ExtrasRequest()
        scheduleType = "instant"
        scheduledAt = nil
    }
}

extension AddressLabel {
    var stringValue: String { rawValue }
}
