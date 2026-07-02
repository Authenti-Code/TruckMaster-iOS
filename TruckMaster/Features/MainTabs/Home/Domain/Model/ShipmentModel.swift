//
//  ShipmentModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation

struct ShipmentModel: Identifiable, Codable {
    let id:            String
    let type:          String
    let trackingID:    String
    let from:          String
    let to:            String
    let status:        String
    let driver:        String
    let estimatedTime: String?
}
