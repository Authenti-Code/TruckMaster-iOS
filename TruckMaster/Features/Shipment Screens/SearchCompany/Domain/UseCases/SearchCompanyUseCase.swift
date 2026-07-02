//
//  SearchCompanyUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

final class SearchCompanyUseCase {
    private let repository: SearchCompanyRepository

    init(repository: SearchCompanyRepository) {
        self.repository = repository
    }

    func execute() async throws -> [CompanyModel] {
        try await repository.fetchCompany()
    }
}
