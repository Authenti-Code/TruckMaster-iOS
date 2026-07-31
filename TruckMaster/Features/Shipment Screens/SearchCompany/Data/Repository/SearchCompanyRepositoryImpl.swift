//
//  SearchCompanyRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

internal import Foundation

final class SearchCompanyRepositoryImpl: SearchCompanyRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchActiveOrder() async throws -> ActiveOrderData {
            let response: BaseResponse<ActiveOrderData> =
        try await apiClient.request(endpoint: .activeOrders, method: .post, body: nil as EmptyModel?)

            guard response.success == "true" else {
                throw NetworkError.apiError(
                    response.message.isEmpty
                        ? "Something went wrong. Please try again."
                        : response.message
                )
            }

            guard let data = response.data else {
                throw NetworkError.apiError("No data returned.")
            }

            return data
        }
}
