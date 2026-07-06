//
//  SettingsState.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

struct SettingsState {
    var profile:        UserModel?      = nil
    var profileData:      ProfileResponse? = nil
    var isLoading:      Bool            = false
    var showSnackbar:   Bool            = false
    var snackbarMessage: String         = ""
   var user: UserModel?
    var snackbarType:   SnackbarType    = .error

    var settingsItems: [SettingsItemModel] = [
        SettingsItemModel(id: "1", icon: ImageConstants.savedAddress,   title: "saved_address_title",      route: .savedAddress),
        SettingsItemModel(id: "2", icon: ImageConstants.account,          title: "account_settings_title",   route: .accountSettings),
        SettingsItemModel(id: "3", icon: ImageConstants.helpSupport,         title: "help_support_title",     route: .helpAndSupport),
        SettingsItemModel(id: "4", icon: ImageConstants.faq, title: "faq_title",              route: .faqs),
        SettingsItemModel(id: "5", icon: ImageConstants.termConditions,           title: "terms_conditions_title", route: .termsAndConditions),
        SettingsItemModel(id: "6", icon: ImageConstants.privacy,             title: "privacy_policy_title",     route: .privacyPolicy)
    ]
}
