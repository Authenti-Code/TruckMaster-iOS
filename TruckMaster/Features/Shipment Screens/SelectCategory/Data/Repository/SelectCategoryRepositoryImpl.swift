//
//  SelectCategoryRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//


final class SelectCategoryRepositoryImpl: NewCategoryRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCategory(request: CategoryListRequest) async throws -> CategoryListResponse {
        let response: BaseResponse<CategoryListResponse> =
            try await apiClient.request(
                endpoint: .category,
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

        return data
    }
}
