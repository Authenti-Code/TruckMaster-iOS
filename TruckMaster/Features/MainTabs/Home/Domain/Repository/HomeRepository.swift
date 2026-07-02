//
//  HomeRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation

protocol HomeRepository {
    func getCurrentShipments() async throws -> [ShipmentModel]
    func getUserProfile() async throws -> ProfileResponse
}
