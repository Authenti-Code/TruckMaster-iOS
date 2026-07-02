//
//  TermsConditionRepository.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

protocol TermsConditionRepository {
    func getTermsCondition(isPolicy: Bool) async throws -> String
}
