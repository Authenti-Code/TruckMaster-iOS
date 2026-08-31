//
//  EndPoints.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import Foundation

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
    case activeOrders
    case getOrders
    case getOfferDetails
    case respondToOffer
    
    //help support
    case getSupportTickets
    case raiseTicket
    case getMessages
    case sendSupportMessage

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
            
        case .activeOrders:
            return "/active-orders"
            
        case .getOfferDetails:
            return "/order/offer/details"
            
        case .respondToOffer:
            return "/order/offer/respond"
            
        //help and support
        case .getSupportTickets:
            return "/support-tickets"
            
        case .raiseTicket:
            return "/support-tickets/raise"
            
        case .getMessages:
            return "/support-tickets/get/messages"
            
        case .sendSupportMessage:
            return "/support-tickets/message"
            
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
