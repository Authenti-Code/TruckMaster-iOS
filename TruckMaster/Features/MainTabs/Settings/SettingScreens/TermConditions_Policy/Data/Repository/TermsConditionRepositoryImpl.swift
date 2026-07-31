//
//  TermsConditionRepositoryImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//


internal import Foundation

final class TermsConditionRepositoryImpl: TermsConditionRepository {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func getTermsCondition(isPolicy: Bool) async throws -> String {
        let response: TermsConditionResponse =
            try await apiClient.request(
                endpoint: isPolicy ? .privacyPolicy : .termsCondition,
                method: .get,
                body: nil as EmptyModel?
            )

        guard response.success == "true" else {
            throw NetworkError.apiError(
                response.message.isEmpty
                    ? "Something went wrong. Please try again."
                    : response.message
            )
        }

        return response.data?.content ?? ""
    }
}
