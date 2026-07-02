//
//  VerifyCodeView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct VerifyCodeView: View {

    @StateObject private var viewModel: VerifyCodeViewModel

    init(viewModel: VerifyCodeViewModel) {
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
                        Button {
                            viewModel.backTapped()
                        } label: {
                            Image(ImageConstants.backImage)
                        }
                        .padding(.bottom, 12)

                        HStack(alignment: .top) {
                            ReusableText(
                                title: "verify_code_title",
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

                // Card
                VStack(alignment: .leading, spacing: 16) {
                    
                    ReusableText(
                        title: "verify_code_subheading",
                        fontSize: 18,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    .padding(.bottom, 2)
                    
                    // OTP Boxes
                    OTPInputField(
                        numberOfFields: 4,
                        otp: viewModel.binding(for: \.state.otp)
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                    
                    Button{
                        viewModel.resendCodeTapped()
                    }label : {ReusableText(
                        title: "resend_code_title",
                        fontSize: 13,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.red1
                    )
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 2)
                    }

                    PrimaryButton(title: "verify_code_btn_title") {
                        viewModel.verifyOtpTapped()
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
        let viewModel = VerifyCodeViewModel(
            verifyCodeUseCase: VerifyCodeUseCase(
                repository: VerifyCodeRepositoryImpl(apiClient: apiClient)
            ),
            router: router
        )
        VerifyCodeView(viewModel: viewModel)
    } else {
        // Fallback on earlier versions
    }
  
}
