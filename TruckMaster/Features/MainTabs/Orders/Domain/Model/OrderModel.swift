//
//  OrderModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

struct OrderModel: Identifiable {
    let id:            String
    let type:          String
    let trackingID:    String
    let driver:        String
    let status:        OrderStatus
    let estimatedTime: String?
}
