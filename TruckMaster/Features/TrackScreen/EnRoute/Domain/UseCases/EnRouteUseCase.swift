//
//  GetOrdersUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//
import Foundation

final class EnRouteUseCase {
    private let repository: EnRouteRepository
    
    init(repository: EnRouteRepository) {
        self.repository = repository
    }
    
    
    func execute() async throws -> [ShipmentModel] {
        try await repository.getOrders()
    }
}
