//
//  SignUpView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 04/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SignUpView: View {

    @StateObject private var viewModel: SignUpViewModel

    @available(iOS 16.0, *)
    init(viewModel: SignUpViewModel) {
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

                    HStack(alignment: .top) {
                        ReusableText(
                            title: "sign_up_title",
                            fontSize: 24,
                            fontName: "Magra-Bold",
                            fontColor: AppColors.textBlack1
                        )
                        Spacer()
                        Image(ImageConstants.truckBanner)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 30)
                }
                .frame(height: 250)

                // Card
                if #available(iOS 16.0, *) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {

                            ReusableText(
                                title: "create_account_title",
                                fontSize: 18,
                                fontName: "Livvic-SemiBold",
                                fontColor: AppColors.textBlack1
                            )
                            .padding(.bottom, 2)

                            // Name
                            LabeledInputField(
                                label: "name_required",
                                hint: "enter_name",
                                isRequired: true,
                                text: viewModel.binding(for: \.state.name)
                            )

                            // Email
                            LabeledInputField(
                                label: "email_address_required",
                                hint: "enter_email",
                                isRequired: true,
                                text: viewModel.binding(for: \.state.email)
                            )

                            // Contact
                            LabeledInputField(
                                label: "contact_required",
                                hint: "enter_contact",
                                isRequired: true,
                                keyboardType: .phonePad,
                                text: viewModel.binding(for: \.state.phone)
                            )

                            // Password
                            LabeledInputField(
                                label: "password_required",
                                hint: "enter_password",
                                isRequired: true,
                                isSecure: true,
                                text: viewModel.binding(for: \.state.password)
                            )

                            // Confirm password
                            LabeledInputField(
                                label: "confirm_password_required",
                                hint: "enter_confirm_password",
                                isRequired: true,
                                isSecure: true,
                                text: viewModel.binding(for: \.state.confirmPassword)
                            )

                            HStack {
                                CheckboxField(
                                    label: "",
                                    isChecked: viewModel.binding(for: \.state.isAgreed)
                                )
                                .onChange(of: viewModel.state.isAgreed) { value in
                                    print("Agreed: \(value)")
                                }
                                Group {
                                    Text(LocalizedStringKey("i_agree_with"))
                                        .foregroundColor(AppColors.grey1)
                                    + Text(" ")
                                    + Text(LocalizedStringKey("terms_conditions"))
                                        .foregroundColor(AppColors.primary)
                                    + Text(" ")
                                    + Text(LocalizedStringKey("and"))
                                        .foregroundColor(AppColors.grey1)
                                    + Text(" ")
                                    + Text(LocalizedStringKey("privacy_policy"))
                                        .foregroundColor(AppColors.primary)
                                }
                                .font(.custom("Livvic-Medium", size: 13))
                                .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 10)

                            PrimaryButton(title: "register_title") {
                                viewModel.registerTapped()
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
                                    viewModel.signInTapped()
                                } label: {
                                    Text(LocalizedStringKey("sign_in_title"))
                                        .font(.custom("Livvic-Regular", size: 14))
                                        .foregroundColor(AppColors.textBlack1)
                                        .underline()
                                }
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 30)
                        .padding(.horizontal, 30)
                    }
                    .scrollIndicators(.hidden)
                    .scrollDismissesKeyboard(.interactively)
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 10)
                    }
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
        let viewModel = SignUpViewModel(
            registerUseCase: SignUpUseCase(
                repository: SignUpRepositoryImpl(apiClient: apiClient)
            ),
            router: router
        )
        SignUpView(viewModel: viewModel)
    } else {
        
    }
   
}
