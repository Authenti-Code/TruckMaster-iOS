//
//  GetPreferredLanguageuseCase.swift
//  TruckMaster
//
//  Created by AuthentiCode on 04/06/26.
//

final class GetPreferredLanguageUseCase{
    private let repository: PreferredLanguageRepository
    
    init(repository: PreferredLanguageRepository) {
        self.repository = repository
    }
    
    func execute() -> [String] {
        return repository.getPreferredLanguage()
    }
}
