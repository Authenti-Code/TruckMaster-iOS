//
//  CategoryListResponse.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

import Foundation



struct CategoryListResponse: Codable {
    let categories: [CategoryModel]
    let totalPages: Int
}


struct CategoryModel: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let hasSubcategories: Bool
    let subCategories: [SubCategoryModel]

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case hasSubcategories = "has_subcategories"
        case subCategories    = "sub_categories"
    }
}

struct SubCategoryModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
