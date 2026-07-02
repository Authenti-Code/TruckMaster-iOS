//
//  CreateOrderUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 26/06/26.
//

protocol CreateOrderUseCase {
    func execute(request: CreateShipmentRequest) async throws
}

final class CreateOrderUseCaseImpl: CreateOrderUseCase {

    private let repository: CreateOrderRepository

    init(repository: CreateOrderRepository) {
        self.repository = repository
    }

    func execute(request: CreateShipmentRequest) async throws {
        try await repository.createOrder(request: request)
    }
}
