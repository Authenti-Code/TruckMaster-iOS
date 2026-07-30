//
//  SignInView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SignInView: View {

    @StateObject private var viewModel: SignInViewModel

    @available(iOS 16.0, *)
    init(viewModel: SignInViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
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

                        HStack(alignment: .top) {
                            ReusableText(
                                title: "sign_in_title",
                                fontSize: 24,
                                fontName: "Magra-Bold",
                                fontColor: AppColors.textBlack1
                            )
                            Spacer()
                            Image(ImageConstants.truckBanner)
                                .frame(height: 130)
                                .frame(maxWidth: 210)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.top, geo.safeAreaInsets.top + 30)
                    }
                    .frame(height: 250)

                    // Card
                    if #available(iOS 16.0, *) {
                        VStack(alignment: .leading, spacing: 16) {

                            ReusableText(
                                title: "welcome_back_title",
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
                                text: viewModel.emailBinding
                            )

                            // Password
                            LabeledInputField(
                                label: "password_required",
                                hint: "enter_password",
                                isRequired: true,
                                isSecure: true,
                                text: viewModel.passwordBinding
                            )

                            //Forgot password text
                            Button {
                                viewModel.forgotPasswordTapped()
                            } label: {
                                Text(LocalizedStringKey("forgot_password_title"))
                                    .font(.custom("Livvic-Regular", size: 14))
                                    .foregroundColor(AppColors.grey1)
                                    .underline()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            
                            PrimaryButton(title: "login_title") {
                                viewModel.loginTapped()
                            }

                            HStack(alignment: .center, spacing: 12) {
                                Spacer()
                                Rectangle()
                                    .frame(width: 60, height: 1.5)
                                    .foregroundColor(AppColors.grey1)
                                ReusableText(
                                    title: "or_continue_with",
                                    fontSize: 15,
                                    fontName: "Rubik-Regular",
                                    fontColor: AppColors.grey1
                                )
                                Rectangle()
                                    .frame(width: 60, height: 1.5)
                                    .foregroundColor(AppColors.grey1)
                                Spacer()
                            }

                            // Social Buttons
                            HStack(spacing: 16) {
                                // Google
                                Button {
                                    viewModel.googleTapped()
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(ImageConstants.googleIcon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        ReusableText(
                                            title: "Google",
                                            fontSize: 16,
                                            fontName: "Livvic-SemiBold",
                                            fontColor: AppColors.textBlack1
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(AppColors.grey2, lineWidth: 1)
                                    )
                                }

                                // Apple
                                Button {
                                    viewModel.appleTapped()
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(ImageConstants.appleIcon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.black)
                                        ReusableText(
                                            title: "Apple",
                                            fontSize: 16,
                                            fontName: "Livvic-SemiBold",
                                            fontColor: AppColors.textBlack1
                                        )
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(AppColors.grey2, lineWidth: 1)
                                    )
                                }
                            }

                            // Have an account
                            HStack(spacing: 4) {
                                Spacer()
                                ReusableText(
                                    title: "have_account",
                                    fontSize: 14,
                                    fontName: "Livvic-Regular",
                                    fontColor: AppColors.grey1
                                )
                                Button {
                                    viewModel.signUpTapped()
                                } label: {
                                    Text(LocalizedStringKey("sign_up_title"))
                                        .font(.custom("Livvic-Regular", size: 14))
                                        .foregroundColor(AppColors.textBlack1)
                                        .underline()
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minHeight: geo.size.height - 250, alignment: .top)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 30)
                        .background(Color.white)
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .overlay(
                            RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
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
        let viewModel = SignInViewModel(
            loginUseCase: SignInUseCase(
                repository: SignInRepositoryImpl(apiClient: apiClient)
            ),
            router: router
        )
        SignInView(viewModel: viewModel)
    } else {
        
    }
}
