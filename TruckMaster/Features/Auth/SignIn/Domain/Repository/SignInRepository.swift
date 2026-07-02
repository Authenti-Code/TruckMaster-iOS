//
//  SignInRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

protocol SignInRepository {
    func login(request: LoginRequestModel) async  throws ->  UserModel
}
