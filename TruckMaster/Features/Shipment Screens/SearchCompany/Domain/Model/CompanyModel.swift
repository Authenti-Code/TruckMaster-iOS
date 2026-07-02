//
//  CompanyModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

struct CompanyModel: Codable, Identifiable, Hashable {
    let id: Int
    let companyName: String
    let price: String
    let rating: String?
    let truckType: String?
    let time: String?
}
