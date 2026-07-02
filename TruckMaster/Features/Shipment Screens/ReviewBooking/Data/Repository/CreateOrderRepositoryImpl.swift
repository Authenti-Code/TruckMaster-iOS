//
//  CreateOrderRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 26/06/26.
//

import Foundation

final class CreateOrderRepositoryImpl: CreateOrderRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func createOrder(request: CreateShipmentRequest) async throws {

        let response: BaseResponse<EmptyResponse> =
            try await apiClient.request(
                endpoint: .createOrder,
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
    }
}
