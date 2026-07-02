//
//  AccountSettingsView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 17/06/26.
//

//
//  AccountSettingsView.swift
//  TruckMaster
//

internal import SwiftUI

@available(iOS 16.0, *)
struct AccountSettingsView: View {
   var viewModel: AccountSettingsViewModel

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
                    title: "account_settings_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            VStack(spacing: 12) {
                SettingsRow(
                    icon: ImageConstants.notification,
                    title: "notifications_title",
                    tintColor: AppColors.textBlack1,
                    action: { viewModel.notificationsTapped() }
                )

                SettingsRow(
                    icon: ImageConstants.change,
                    title: "change_password_title",
                    tintColor: AppColors.textBlack1,
                    action: { viewModel.changePasswordTapped() }
                )

                SettingsRow(
                    icon: ImageConstants.delete,
                    title: "delete_account_title",
                    tintColor: AppColors.colorRed2,
                    action: { viewModel.deleteAccountTapped() }
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()
        }
        .navigationBarHidden(true)
        
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: LocalizedStringKey
    let tintColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                ReusableText(
                    title: title,
                    fontSize: 15,
                    fontName: "Livvic-Medium",
                    fontColor: tintColor
                )

                Spacer()

                Image(ImageConstants.rightArrowS)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.grey1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
        }
    }
}
