//
//  SplashViewModel.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI
internal import Combine

@available(iOS 16.0, *)
@MainActor
final class SplashViewModel: ObservableObject {

    @Published var state: SplashState = .idle

    private let checkAppLaunchUseCase: CheckAppLaunchUseCase
    private let router: AppRouter

    init(
        checkAppLaunchUseCase: CheckAppLaunchUseCase,
        router: AppRouter
    ) {
        self.checkAppLaunchUseCase = checkAppLaunchUseCase
        self.router = router
    }

    func onAppear() {
        state = .loading

        Task {
            try? await Task.sleep(for: .seconds(3))
            let route = checkAppLaunchUseCase.execute()
            router.navigate(to: route)
        }
    }
}
