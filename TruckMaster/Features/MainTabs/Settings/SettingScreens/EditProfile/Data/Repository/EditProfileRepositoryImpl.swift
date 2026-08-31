//
//  EditProfileRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import Foundation
internal import UIKit

final class EditProfileRepositoryImpl: EditProfileRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func updateProfile(
        request: EditProfileRequestModel,
        image: UIImage?
    ) async throws -> String {

        let response: EditProfileResponse =
            try await apiClient.multipartRequest(
                endpoint: .updateProfile,
                method: .post,
                parameters: [
                    "name": request.name,
                    "email": request.email,
                    "phone_number": request.contact
                ],
                image: image,
                imageKey: "profile_image"
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(response.message)
        }

        return response.message
    }
}
