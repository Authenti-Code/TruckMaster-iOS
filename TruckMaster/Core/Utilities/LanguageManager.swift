//
//  LanguageManager.swift
//  TruckMaster
//

internal import SwiftUI
internal import Combine

final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    @Published var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "appLanguage")
        }
    }

    private init() {
        self.language = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
    }

    var isArabic: Bool {
        language == "ar"
    }

    var layoutDirection: LayoutDirection {
        isArabic ? .rightToLeft : .leftToRight
    }

    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }

        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
