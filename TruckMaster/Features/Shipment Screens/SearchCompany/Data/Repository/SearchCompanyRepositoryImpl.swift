//
//  SearchCompanyRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

final class SearchCompanyRepositoryImpl: SearchCompanyRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCompany() async throws -> [CompanyModel] {
        if #available(iOS 16.0, *) {
            try? await Task.sleep(for: .seconds(2))
        } else {
            // Fallback on earlier versions
        }

        return [
            CompanyModel(id: 1, companyName: "Swift Movers", price: "120", rating: "4.8", truckType: "Medium Truck", time: "25 min"),
            CompanyModel(id: 2, companyName: "Quick Haul", price: "95", rating: "4.5", truckType: "Small Van", time: "15 min"),
            CompanyModel(id: 3, companyName: "Heavy Lifters", price: "200", rating: "4.9", truckType: "Large Truck", time: "40 min"),
            CompanyModel(id: 4, companyName: "City Cargo", price: "80", rating: "4.3", truckType: "Small Van", time: "10 min"),
        ]
    }
}
