//
//  EnRouteRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

final class EnRouteRepositoryImpl: EnRouteRepository {
    
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getOrders() async throws -> [ShipmentModel] {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(1.5))
        } else {
            // Fallback on earlier versions
        }
        return [
            ShipmentModel(
                id: "1",
                type: "Pickup Truck",
                trackingID: "#123123123123",
                from: "Shopping Center",
                to: "Exotic Mall",
                status: "En-route",
                driver: "Ron Wisley",
                estimatedTime: "15 min"
            ),
            ShipmentModel(
                id: "2",
                type: "Pickup Truck",
                trackingID: "#123123123124",
                from: "City Mall",
                to: "Airport",
                status: "Delivered",
                driver: "John Smith",
                estimatedTime: nil
            ),
            ShipmentModel(
                id: "3",
                type: "Cargo Van",
                trackingID: "#456456456456",
                from: "Warehouse District",
                to: "Downtown Hub",
                status: "En-route",
                driver: "Sarah Connor",
                estimatedTime: "30 min"
            ),
            ShipmentModel(
                id: "4",
                type: "Mini Truck",
                trackingID: "#789789789789",
                from: "North Station",
                to: "South Plaza",
                status: "Delivered",
                driver: "Mike Johnson",
                estimatedTime: nil
            ),
            ShipmentModel(
                id: "5",
                type: "Flatbed Truck",
                trackingID: "#321321321321",
                from: "Industrial Zone",
                to: "Retail Park",
                status: "En-route",
                driver: "David Lee",
                estimatedTime: "45 min"
            ),
            ShipmentModel(
                id: "6",
                type: "Pickup Truck",
                trackingID: "#654654654654",
                from: "Riverside Depot",
                to: "Central Market",
                status: "Delivered",
                driver: "Emma Wilson",
                estimatedTime: nil
            ),
            ShipmentModel(
                id: "7",
                type: "Cargo Van",
                trackingID: "#987987987987",
                from: "Eastside Warehouse",
                to: "West End Mall",
                status: "En-route",
                driver: "Chris Brown",
                estimatedTime: "20 min"
            )
        ]
        
    }
    
    
}
