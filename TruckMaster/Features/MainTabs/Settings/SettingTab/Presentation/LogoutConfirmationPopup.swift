//
//  LogoutConfirmationPopup.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/07/26.
//

internal import SwiftUI

struct LogoutConfirmationPopup: View {
    var onCancel: () -> Void
    var onLogout: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: 24) {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 72, height: 72)
                                .shadow(
                                    color: Color.black.opacity(0.15),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                                

                            Image(ImageConstants.logout)
                            .font(.system(size: 26, weight: .medium))
                            .foregroundColor(.red)
                                
                        }
                        .padding(.top, 12)
                        .padding(.leading, 12)

                        VStack(spacing: 10) {
                            
                            ReusableText(title: "are_you_sure", fontSize: 20, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                             ReusableText(title: "are_you_sure_desc", fontSize: 15, fontName: "Livvic-Regular", fontColor: AppColors.textBlack1)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 8)

                        HStack(spacing: 12) {
                            Button(action: onCancel) {
                                
                                ReusableText(title: "cancel_title", fontSize: 14, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(AppColors.grey6)
                                    .cornerRadius(28)
                            }

                            Button(action: onLogout) {
                                ReusableText(title: "logout_title", fontSize: 14, fontName: "Livvic-SemiBold", fontColor: .white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(AppColors.red3)
                                    .cornerRadius(28)
                            }
                        }
                    }
                    .padding(24)

                    Button(action: onCancel) {
                        Image(ImageConstants.cross)
                          
                    }
                    .padding(12)
                }
                .background(Color(.systemBackground))
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    LogoutConfirmationPopup(onCancel: {}, onLogout: {})
}
