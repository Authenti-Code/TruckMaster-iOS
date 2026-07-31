//
//  GetTermsConditionUseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import Foundation

final class GetTermsConditionUseCase {

    private let repository: TermsConditionRepository

    init(repository: TermsConditionRepository) {
        self.repository = repository
    }

    func execute(isPolicy: Bool) async throws -> String {
        try await repository.getTermsCondition(isPolicy: isPolicy)
    }
}
