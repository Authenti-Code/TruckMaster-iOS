//
//  EnRouteRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

protocol EnRouteRepository {
    func getOrders() async throws -> [ShipmentModel]
}
