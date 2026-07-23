//
//  PreferredLanguageViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 04/06/26.
//

internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class PreferredLanguageViewModel: ObservableObject {
    

    @Published var languages: [String] = []
    @Published var selectedLanguage: String = "" {
        didSet {
            changeLanguage(selected: selectedLanguage)
        }
    }

    private let getPreferredLanguageUseCase: GetPreferredLanguageUseCase
    private let router: AppRouter

    init(getPreferredLanguageUseCase: GetPreferredLanguageUseCase, router: AppRouter) {
         self.getPreferredLanguageUseCase = getPreferredLanguageUseCase
         self.router = router
     }

    func onAppear() {
        languages = getPreferredLanguageUseCase.execute()

        let savedCode = UserPreferences.shared.selectedLanguage

        selectedLanguage = AppLanguage.allCases
            .first { $0.code == savedCode }?
            .rawValue
            ?? languages.first
            ?? ""
    }

    func continueTapped() {
        router.navigate(to: .signIn)
    }

    func backTapped() {
        router.navigateBack()
    }

    private func changeLanguage(selected: String) {
        let code = AppLanguage.allCases
            .first { $0.rawValue == selected }?.code ?? "en"

        LanguageManager.shared.language = code
        UserPreferences.shared.selectedLanguage = code
    }
}
