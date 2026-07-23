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
                                .fill(Color(.systemGray6))
                                .frame(width: 72, height: 72)

                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                                            .font(.system(size: 26, weight: .medium))
                                                            .foregroundColor(.red)
                                
                        }
                        .padding(.top, 8)

                        VStack(spacing: 10) {
                            
                            ReusableText(title: "are_you_sure", fontSize: 24, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                             ReusableText(title: "are_you_sure_desc", fontSize: 18, fontName: "Livvic-Regular", fontColor: AppColors.textBlack1)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 8)

                        HStack(spacing: 12) {
                            Button(action: onCancel) {
                                Text("cancel_title")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(26)
                            }

                            Button(action: onLogout) {
                                Text("logout_title")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.red)
                                    .cornerRadius(26)
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
