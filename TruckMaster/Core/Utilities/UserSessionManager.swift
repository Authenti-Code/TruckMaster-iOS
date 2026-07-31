//
//  UserSessionManager.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import Foundation
internal import Combine

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    @Published var currentUser: UserModel?
    
    private init() {}
}
