//
//  OrderModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

struct EnRouteModel: Identifiable {
    let id: String
    let type: String
    let trackingID: String
    let from: String
    let to: String
    let status: String
    let driver: String
    let estimatedTime: String?
}
