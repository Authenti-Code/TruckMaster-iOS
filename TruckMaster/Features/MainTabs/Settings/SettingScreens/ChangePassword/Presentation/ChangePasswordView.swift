//
//  ChangePasswordView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//


internal import SwiftUI

@available(iOS 16.0, *)
struct ChangePasswordView: View {
    @ObservedObject var viewModel: ChangePasswordViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(
                    title: "change_password_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ReusableText(
                        title: "change_password_subheading",
                        fontSize: 14,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.grey1
                    )

                    LabeledInputField(
                        label: "old_password_required",
                        hint: "enter_old_password",
                        isRequired: true,
                        isSecure: true,
                        isMultiline: true,
                        lineLimit: 1...2,
                        text: viewModel.oldPasswordBinding
                    )

                    LabeledInputField(
                        label: "new_password_required",
                        hint: "enter_new_password",
                        isRequired: true,
                        isSecure: true,
                        isMultiline: true,
                        lineLimit: 1...2,
                        text: viewModel.newPasswordBinding
                    )

                    LabeledInputField(
                        label: "confirm_password_required",
                        hint: "enter_confirm_password",
                        isRequired: true,
                        isSecure: true,
                        isMultiline: true,
                        lineLimit: 1...2,
                        text: viewModel.confirmPasswordBinding
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)

            PrimaryButton(title: "update_title") {
                viewModel.updateTapped()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView().tint(.white).scaleEffect(1.5)
            }
        }
        .dismissKeyboardOnTap()
    }
}
