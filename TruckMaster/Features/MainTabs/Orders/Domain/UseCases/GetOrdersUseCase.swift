//
//  GetOrdersUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation

final class GetOrdersUseCase {

    private let repository: OrdersRepository

    init(repository: OrdersRepository) {
        self.repository = repository
    }

    func execute(page: Int = 1) async throws -> [OrderModel] {
        try await repository.getOrders(page: page)
    }
}
