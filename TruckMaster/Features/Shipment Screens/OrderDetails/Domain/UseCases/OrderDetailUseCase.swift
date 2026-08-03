//
//  OrderDetailUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

final class OrderDetailUseCase {
    private let repository: OrderDetailRepository

    init(repository: OrderDetailRepository) {
        self.repository = repository
    }

    func execute(orderId: String, companyId: Int) async throws -> OrderOfferDetail {
        try await repository.fetchOrderDetail(
            request: OrderDetailRequest(orderId: orderId, companyId: companyId)
        )
    }

    func respond(status: String, orderId: String, companyId: String) async throws -> OrderOfferRespondData {
        try await repository.respondToOffer(
            request: OrderOfferRespondRequest(status: status, orderId: orderId, companyId: companyId)
        )
    }
}
