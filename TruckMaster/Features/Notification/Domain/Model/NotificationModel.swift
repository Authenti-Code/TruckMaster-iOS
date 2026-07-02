//
//  NotificationModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

struct NotificationModel: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let message: String
    let icon: String?
}
