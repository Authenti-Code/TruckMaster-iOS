//
//  EndPoints.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

import Foundation

enum EndPoints {

    case register
    case login
    case logout
    case forgotPassword
    case verifyOtp
    case resendOtp
    case updatePassword
    case changePassword
    case getAddress
    case deleteAddress
    case termsCondition
    case privacyPolicy
    case updateProfile
    case addAddress
    case updateAddress
    case profile
    case deleteAccount
    
    //shimpent
    case category
    case createOrder
    case getOrders

    var path: String {

        switch self {
            
        case .register:
            return "/register"
            
        case .login:
            return "/login"
        
        case .logout:
            return "/logout"
            
        case .forgotPassword:
            return "/forgot-password"
        
        case .verifyOtp:
            return "/verify-otp"
            
        case .resendOtp:
            return "/otp/resend"
        
        case .updatePassword:
            return "/set-new-password"
            
            
        //Setting screen api
        case .termsCondition:
            return "/terms-condition"
        
        case .privacyPolicy:
            return "/privacy-policy"
            
        case .updateProfile:
            return "/profile/update"
            
        case .getAddress:
            return "/address"
        
        case .addAddress:
            return "/address/add"
            
        case .deleteAddress:
            return "/address/delete"
            
        case .updateAddress:
            return "/address/update"
            
        case .changePassword:
            return "/profile/update/password"
        
        case .deleteAccount:
            return "/account/delete"
            
            
        
        //Shipment
        case .profile:
            return "/profile"
       
        case .category:
            return "/category"
            
        case .createOrder:
            return "/order/create"
            
        case .getOrders:
            return "/orders"
        }
    }

    var url: URL {

        URL(
            string: ApiConstants.userBaseURL + path
        )!
    }
}


//Usage

//EndPoints.register.url
