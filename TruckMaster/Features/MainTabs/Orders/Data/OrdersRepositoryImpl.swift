//
//  OrdersRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//


internal import Foundation

final class OrdersRepositoryImpl: OrdersRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getOrders(request: OrderListRequest) async throws -> [OrderResponse] {
        let response: BaseResponse<OrderListData> =
            try await apiClient.request(
                endpoint: .getOrders,
                method: .post,
                body: request
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        guard let data = response.data else {
            throw NetworkError.apiError("No category data received.")
        }

        return data.orders
    }
}
