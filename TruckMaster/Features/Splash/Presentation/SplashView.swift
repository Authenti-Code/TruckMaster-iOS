//
//  SplashView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SplashView: View {

    @StateObject private var viewModel: SplashViewModel

    init(viewModel: SplashViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {

        ZStack {

            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Image(ImageConstants.logo)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
#Preview {
  
  
   
}

