//
//  SearchCompanyRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//
//
//  SearchCompanyRepository.swift
//  TruckMaster
//

internal import Foundation

protocol SearchCompanyRepository {
    func fetchActiveOrder() async throws -> ActiveOrderData
}
