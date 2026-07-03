//
//  OrdersRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation

protocol OrdersRepository {
    func getOrders(request: OrderListRequest) async throws -> [OrderResponse]
}
