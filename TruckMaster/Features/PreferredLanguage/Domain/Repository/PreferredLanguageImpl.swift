//
//  PreferredLanguageImpl.swift
//  TruckMaster
//
//  Created by AuthentiCode on 04/06/26.
//

final class PreferredLanguageRepositoryImpl: PreferredLanguageRepository {
    func getPreferredLanguage() -> [String] {
       
        return AppLanguage.allCases.map { $0.rawValue }
    }
}
