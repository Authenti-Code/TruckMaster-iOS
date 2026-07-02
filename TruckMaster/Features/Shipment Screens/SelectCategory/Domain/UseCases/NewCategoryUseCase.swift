//
//  NewCategoryUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

final class NewCategoryUseCase {
    private let repository: NewCategoryRepository

    init(repository: NewCategoryRepository) {
        self.repository = repository
    }

    func execute(request: CategoryListRequest) async throws -> CategoryListResponse {
        try await repository.fetchCategory(request: request)
    }
}
