//
//  SettingsViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//

import Foundation
internal import Combine
import UIKit
internal import SwiftUI

@available(iOS 16.0, *)
@MainActor
final class TermsConditionViewModel: ObservableObject {

    @Published var state = TermsConditionState()

    private let getTermsConditionUseCase: GetTermsConditionUseCase
    private let router: AppRouter
    let isPolicy: Bool

    init(
        getTermsConditionUseCase: GetTermsConditionUseCase,
        router: AppRouter,
        isPolicy: Bool
    ) {
        self.getTermsConditionUseCase = getTermsConditionUseCase
        self.router                   = router
        self.isPolicy                 = isPolicy
    }

    func onAppear() {
        Task { await loadContent() }
    }

    func backTapped() {
        router.navigateBack()
    }

    private func loadContent() async {
        state.isLoading = true
        defer { state.isLoading = false }
        do {
            state.content = try await getTermsConditionUseCase.execute(isPolicy: isPolicy)
        } catch {
            triggerError(error.localizedDescription)
        }
    }

    private func triggerError(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .error
        state.showSnackbar    = true
    }

    private func triggerSuccess(_ message: String) {
        state.snackbarMessage = message
        state.snackbarType    = .success
        state.showSnackbar    = true
    }
}
