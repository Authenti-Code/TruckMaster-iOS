//
//  AppConstants.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

import Foundation
internal import SwiftUI

enum ImageConstants {

    static let logo = "logo"

    static let onboardingImage =
        "onboard_img"
    
    static let backImage =
        "back_btn_img"
    
    static let gradient1 =
        "gradient_1"
    
    static let lineGradient =
        "line_gradient"
    
    static let truckBanner =
        "truck_banner"
    
    static let eyeSlash = "ic_eye_slash"
    static let eye = "ic_eye"
    
    static let googleIcon =
        "ic_google"
    
    static let appleIcon =
        "ic_apple"
    
    //MainTabs icons and images
    static let completed = "completed"
    static let greenDot = "ic_green_dot"
    static let line = "ic_line"
    static let icDropLocation = "ic_drop_location"
    static let downArrow = "ic_down"
    static let cross = "ic_close"
    static let startFilled = "ic_star_filled"
    static let startEmpty = "ic_star_empty"
    static let calling = "ic_calling"
    static let line1 = "line1"
    static let date = "ic_date"
    static let time = "ic_time"
    
    //Home icons
    static let homeUnSelected = "ic_home_unselected"
    static let homeSelected = "ic_home_selected"
    static let icLocation = "ic_location"
    static let icNotification = "ic_notification"
    static let rightArrow = "ic_right_arrow"
    static let truckImage = "truck_img"
    static let deliveryBoxImage = "box_img"
    static let truckImage1 = "truck_img_1"
    static let truckImage2 = "truck_img_2"
    
    
    //Notificaiton
    static let noNotificaitons = "no_notifications"
    static let driverAlert = "ic_notificaiton_driver_alert"
    
    //Orders icons
    static let ordersUnSelected = "ic_orders_unselected"
    static let ordersSelected = "ic_orders_selected"
    static let emptyOrders = "ic_no_orders"
    static let orderBox = "ic_order"
    
    //Settings icons
    static let settingsUnSelected = "ic_settings_unselected"
    static let settingsSelected = "ic_settings_selected"
    static let user = "ic_user"
    static let edit = "ic_edit"
    static let savedAddress = "ic_saved_address"
    static let account = "ic_account"
    static let helpSupport = "ic_help_support"
    static let faq = "ic_faq"
    static let termConditions = "ic_term_conditions"
    static let privacy = "ic_privacy"
    static let rightArrowS = "ic_chevron_right"
    static let location = "ic_location_pin"
    static let marker = "ic_location_marker"
    static let gps = "ic_gps"
    static let search = "ic_search"
    static let homeAddressSelected = "ic_address_home_selected"
    static let homeAddressUnselected = "ic_address_home_unselected"
    static let shopAddressSelected = "ic_address_shop_selected"
    static let shopAddressUnselected = "ic_address_shop_unselected"
    static let otherAddressSelected = "ic_address_other_selected"
    static let otherAddressUnselected = "ic_address_other_unselected"
    static let trash = "ic_trash"
    static let notification = "ic_notification_unselected"
    static let noSavedAddress = "no_saved_address"
    static let change = "ic_change"
    static let delete = "ic_delete"
    static let send = "ic_send"
    
        
}


enum AppLanguage: String, CaseIterable {
    case english = "English (US)"
    case arabic = "Arabic (العربية)"
    
    var code: String {
        switch self {
        case .english: return "en"
        case .arabic:  return "ar"
        }
    }
}


enum ComingFrom: String {
    case shipmentPickup = "shipment_pickup"
    case shipmentDrop = "shipment_drop"
    case shipmentChangeAddress = "shipment_change_address"
    case addAddress = "add_address"
    case addressChangeAddress = "address_change_address"
}

enum MeasurementUnit: String, CaseIterable {
    case cm = "Centimeter (cm)"
    case m = "Meter (m)"
    case inch = "Inch (in)"

    var apiValue: String {
        switch self {
        case .cm:
            return "cm"
        case .m:
            return "m"
        case .inch:
            return "in"
        }
    }
}



enum OrderStatus {
    case enRoute
    case delivered

    var label: String {
        switch self {
        case .enRoute:   return "En-route"
        case .delivered: return "Delivered"
        }
    }

    var textColor: Color {
        switch self {
        case .enRoute:   return AppColors.colorRed1
        case .delivered: return AppColors.colorGreen1
        }
    }

    var backgroundColor: Color {
        switch self {
        case .enRoute:   return AppColors.colorPink1
        case .delivered: return AppColors.colorGreen
        }
    }
}
