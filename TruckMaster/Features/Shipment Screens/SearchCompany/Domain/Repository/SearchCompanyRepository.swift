//
//  SearchCompanyRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

protocol SearchCompanyRepository {
    func fetchCompany() async throws -> [CompanyModel]
}
