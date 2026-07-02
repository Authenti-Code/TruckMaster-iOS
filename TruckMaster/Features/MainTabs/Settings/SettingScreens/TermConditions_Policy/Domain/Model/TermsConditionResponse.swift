//
//  TermsConditionResponse.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

struct TermsConditionResponse: Codable {
    let success: String
    let message: String
    let data:    TermsConditionModel?
}
