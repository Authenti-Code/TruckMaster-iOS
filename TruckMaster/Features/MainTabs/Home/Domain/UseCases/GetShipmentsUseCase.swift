//
//  GetShipmentsUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

internal import Foundation

final class GetShipmentsUseCase {

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func execute() async throws -> [ShipmentModel] {
        try await repository.getCurrentShipments()
    }
    
    func executeGetProfile() async throws -> ProfileResponse {
        try await repository.getUserProfile()
    }
}
