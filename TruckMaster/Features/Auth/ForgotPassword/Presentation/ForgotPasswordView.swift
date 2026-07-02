//
//  ForgotPasswordView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct ForgotPasswordView: View {

    @StateObject private var viewModel: ForgotPasswordViewModel

    init(viewModel: ForgotPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {

                // Header
                ZStack(alignment: .topLeading) {
                    Image(ImageConstants.gradient1)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 250)
  	                      .clipped()

                    Image(ImageConstants.lineGradient)
                        .resizable()
                        .frame(width: geo.size.width, height: 250)
                        .clipped()

                    VStack(alignment: .leading, spacing: 0) {
                        // Back button
                        Button {
                            viewModel.backTapped()
                        } label: {
                            Image(ImageConstants.backImage)
                        }
                        .padding(.bottom, 12)

                        HStack(alignment: .top) {
                            ReusableText(
                                title: "forgot_password_title",
                                fontSize: 24,
                                fontName: "Magra-Bold",
                                fontColor: AppColors.textBlack1
                            )
                            Spacer()
                            Image(ImageConstants.truckBanner)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 20)
                }
                .frame(height: 250)

                VStack(alignment: .leading, spacing: 16) {

                    ReusableText(
                        title: "forgot_password_subheading",
                        fontSize: 18,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    .padding(.bottom, 2)

                    // Email
                    LabeledInputField(
                        label: "email_address_required",
                        hint: "enter_email",
                        isRequired: true,
                        text: viewModel.binding(for: \.state.email)
                    )
                    .padding(.bottom, 20)

                    PrimaryButton(title: "send_code_title") {
                        viewModel.sendOTPTapped()
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.vertical, 30)
                .padding(.horizontal, 30)
                .background(Color.white)
                .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                .overlay(
                    RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
            .ignoresSafeArea(edges: .top)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .dismissKeyboardOnTap()
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        let router = AppRouter()
        let apiClient: APIClientProtocol = APIClient()
        let viewModel = ForgotPasswordViewModel(
            forgotPasswordUseCase: ForgotPasswordUseCase(
                repository: ForgotPasswordRepositoryImpl(apiClient: apiClient)
            ),
            router: router
        )
        ForgotPasswordView(viewModel: viewModel)
    } else {
        // Fallback on earlier versions
    }
   
}
