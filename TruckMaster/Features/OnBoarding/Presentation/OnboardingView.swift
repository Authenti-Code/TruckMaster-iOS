//
//  OnBoardingView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct OnboardingView: View {

    @StateObject private var viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        ZStack {
            // Image
            Image(ImageConstants.onboardingImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Gradient at bottom only
            VStack {
                Spacer()
                LinearGradient(
                    colors: [Color.black.opacity(0.7), Color.black.opacity(0.0)],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 350)
                .blur(radius: 10)
            }
            .ignoresSafeArea()

            // Main Content
            VStack(alignment: .leading) {

                // Title
                VStack(alignment: .leading, spacing: 0) {
                    Text(LocalizedStringKey("book_track"))
                        .font(.custom("Magra-Bold", size: 38))
                        .foregroundColor(.black)

                    Text(LocalizedStringKey("done"))
                        .font(.custom("Magra-Bold", size: 38))
                        .foregroundColor(AppColors.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

                Spacer()

                // Bottom Section
                VStack(alignment: .leading, spacing: 24) {
                    Text(LocalizedStringKey("onboard_subheading"))
                        .font(.custom("Livvic-Medium", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    PrimaryButton(title: "next_text") {
                        viewModel.nextTapped()
                    }
                }
                .padding(.horizontal, 20)
                
                .padding(.bottom, 34)
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        let router = AppRouter()
        let viewModel = OnboardingViewModel(
            getOnboardingUseCase: GetOnboardingUseCase(
                repository: OnboardingRepositoryImpl()
            ),
            router: router
        )
        OnboardingView(viewModel: viewModel)
    }
}
