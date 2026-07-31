//
//  HomeRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

internal import Foundation

final class HomeRepositoryImpl: HomeRepository {
    func getUserProfile() async throws -> ProfileResponse {
        let response: ProfileResponse =
            try await apiClient.request(
                endpoint: .profile,
                method: .get,
                body: nil as EmptyModel?
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        return response
    }
    

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getCurrentShipments() async throws -> [ShipmentModel] {

        // TODO: Replace with real API call
        // let response: ShipmentListResponse =
        //     try await apiClient.request(
        //         endpoint: .getShipments,
        //         method: .get,
        //         body: EmptyModel()
        //     )
        // return response.data
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
