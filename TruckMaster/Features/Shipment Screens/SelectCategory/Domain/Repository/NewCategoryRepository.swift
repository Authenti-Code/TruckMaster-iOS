//
//  NewCategoryRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

protocol NewCategoryRepository {
    func fetchCategory(request: CategoryListRequest) async throws -> CategoryListResponse
}
