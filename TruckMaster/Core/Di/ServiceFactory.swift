//
//  ServiceFactory.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

import Foundation

final class ServiceFactory {

    static func makeAPIClient() -> ApiClient {
        ApiClient()
    }
}


//usage
//let apiClient = ServiceFactory.makeAPIClient()
