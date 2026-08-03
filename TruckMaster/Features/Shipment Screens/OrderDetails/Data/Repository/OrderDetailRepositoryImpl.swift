//
//  OrderDetailRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

internal import Foundation
final class OrderDetailRepositoryImpl: OrderDetailRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchOrderDetail(request: OrderDetailRequest) async throws -> OrderOfferDetail {
        let response: BaseResponse<OrderOfferDetail> =
            try await apiClient.request(
                endpoint: .getOfferDetails,
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
            throw NetworkError.apiError("No offer detail data received.")
        }

        return data
    }

    func respondToOffer(request: OrderOfferRespondRequest) async throws -> OrderOfferRespondData {
        let response: BaseResponse<OrderOfferRespondData> =
            try await apiClient.request(
                endpoint: .respondToOffer,
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
            throw NetworkError.apiError("No response data received.")
        }

        return data
    }
}
