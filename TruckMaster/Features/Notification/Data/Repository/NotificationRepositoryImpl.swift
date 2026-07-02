//
//  NotificationRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

final class NotificationRepositoryImpl: NotificationRepository {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchNotifications() async throws -> [NotificationModel] {
        // TODO: replace with real endpoint once available
        try await Task.sleep(nanoseconds: 500_000_000)

        return [
               NotificationModel(
                   id: 1,
                   title: "Driver alert",
                   message: "Company has assign a driver for your order",
                   icon: ImageConstants.driverAlert
               ),
               NotificationModel(
                   id: 2,
                   title: "Order picked up",
                   message: "Your shipment has been picked up and is on its way",
                   icon: ImageConstants.driverAlert
               ),
               NotificationModel(
                   id: 3,
                   title: "Delivery delayed",
                   message: "Your order is running a bit late due to traffic conditions",
                   icon: ImageConstants.driverAlert
               ),
               NotificationModel(
                   id: 4,
                   title: "Order delivered",
                   message: "Your shipment has been delivered successfully",
                   icon: ImageConstants.driverAlert
               ),
               NotificationModel(
                   id: 5,
                   title: "Payment received",
                   message: "We've received your payment for order #4521",
                   icon: ImageConstants.driverAlert
               ),
               NotificationModel(
                   id: 6,
                   title: "New promo available",
                   message: "Get 15% off your next shipment this week only",
                   icon: ImageConstants.driverAlert
               )
           ]
    }
}
