//
//  EditProfileRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import UIKit

protocol EditProfileRepository {

    func updateProfile(
        request: EditProfileRequestModel,
        image: UIImage?
    ) async throws -> String
}
