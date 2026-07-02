//
//  UserSessionManager.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

import Foundation
internal import Combine

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    @Published var currentUser: UserModel?
    
    private init() {}
}
