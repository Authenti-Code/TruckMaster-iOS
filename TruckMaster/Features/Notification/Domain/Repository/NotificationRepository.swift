//
//  NotificationRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

protocol NotificationRepository {
    func fetchNotifications() async throws -> [NotificationModel]
}
