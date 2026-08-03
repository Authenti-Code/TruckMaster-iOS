//
//  OrderDetailRequest.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/08/26.
//

//
//  OrderOfferDetailRequest.swift
//  TruckMaster
//

struct OrderDetailRequest: Codable {
    let orderId: String
    let companyId: Int

    enum CodingKeys: String, CodingKey {
        case orderId   = "order_id"
        case companyId = "company_id"
    }
}

struct OrderOfferRespondRequest: Codable {
    let status: String
    let orderId: String
    let companyId: String

    enum CodingKeys: String, CodingKey {
        case status
        case orderId   = "order_id"
        case companyId = "company_id"
    }
}
