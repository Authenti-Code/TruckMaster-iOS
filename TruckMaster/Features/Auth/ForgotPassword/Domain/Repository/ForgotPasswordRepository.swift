//
//  ForgotPasswordRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

import Foundation

protocol ForgotPasswordRepository {
    func forgotPassword(request: ForgotPasswordRequestModel) async throws -> (ForgotPasswordResponseModel, String)
}
