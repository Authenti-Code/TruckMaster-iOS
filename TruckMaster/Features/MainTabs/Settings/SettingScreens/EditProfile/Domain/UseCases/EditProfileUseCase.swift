//
//  EditProfileUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import Foundation
internal import UIKit

final class EditProfileUseCase {

    private let repository: EditProfileRepository

    init(repository: EditProfileRepository) {
        self.repository = repository
    }

    func execute(
        request: EditProfileRequestModel,
        image: UIImage?
    ) async throws -> String {

        try await repository.updateProfile(
            request: request,
            image: image
        )
    }
}
