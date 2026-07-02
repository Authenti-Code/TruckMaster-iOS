//
//  Address.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//


struct Address {
    let id: Int
    let address: String
    let name: String
    let phoneNumber: String
    let label: AddressLabel
    let latitude: String
    let longitude: String
    let isDefault: Bool
}

enum AddressLabel: String, CaseIterable {
    case home = "home"
    case shop = "shop"
    case other = "other"

    var displayName: String {
        switch self {
        case .home:  return "Home"
        case .shop:  return "Shop"
        case .other: return "Other"
        }
    }

    var icon: String {
        switch self {
        case .home:  return ImageConstants.homeAddressUnselected
        case .shop:  return ImageConstants.shopAddressUnselected
        case .other: return ImageConstants.otherAddressUnselected
        }
    }

    var selectedIcon: String {
        switch self {
        case .home:  return ImageConstants.homeAddressSelected
        case .shop:  return ImageConstants.shopAddressSelected
        case .other: return ImageConstants.otherAddressSelected
        }
    }
}
