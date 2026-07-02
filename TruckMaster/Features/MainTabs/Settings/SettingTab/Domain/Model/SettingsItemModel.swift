//
//  SettingsItemModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

struct SettingsItemModel: Identifiable {
    let id:    String
    let icon:  String
    let title: String
    let route: SettingsRoute
}

enum SettingsRoute {
    case savedAddress
    case accountSettings
    case helpAndSupport
    case faqs
    case termsAndConditions
    case privacyPolicy
}
