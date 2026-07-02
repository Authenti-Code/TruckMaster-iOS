//
//  CreateOrderRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 26/06/26.
//

protocol CreateOrderRepository {
    func createOrder(request: CreateShipmentRequest) async throws
}
