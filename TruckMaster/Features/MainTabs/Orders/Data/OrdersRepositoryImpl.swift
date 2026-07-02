//
//  OrdersRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//


import Foundation

final class OrdersRepositoryImpl: OrdersRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getOrders(page: Int) async throws -> [OrderModel] {

        // simulate network delay
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(1.5))
        } else {
            // Fallback on earlier versions
        }

        // TODO: replace with real API call
        guard page <= 2 else { return [] }

        let all: [OrderModel] = [
            OrderModel(id: "1", type: "Pickup Truck",  trackingID: "#123123123123", driver: "Ron Wisley",   status: .enRoute,   estimatedTime: "15 min"),
            OrderModel(id: "2", type: "Pickup Truck",  trackingID: "#123123123124", driver: "John Smith",   status: .delivered, estimatedTime: nil),
            OrderModel(id: "3", type: "Cargo Van",     trackingID: "#456456456456", driver: "Sarah Connor", status: .enRoute,   estimatedTime: "30 min"),
            OrderModel(id: "4", type: "Mini Truck",    trackingID: "#789789789789", driver: "Mike Johnson", status: .delivered, estimatedTime: nil),
            OrderModel(id: "5", type: "Flatbed Truck", trackingID: "#321321321321", driver: "David Lee",    status: .enRoute,   estimatedTime: "45 min"),
            OrderModel(id: "6", type: "Pickup Truck",  trackingID: "#654654654654", driver: "Emma Wilson",  status: .delivered, estimatedTime: nil),
        ]
//        let all: [OrderModel] = []

        let offset = (page - 1) * 3
        return Array(all.dropFirst(offset).prefix(3))
    }
}
