//
//  DeleteAccountView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct DeleteAccountView: View {

    @ObservedObject var viewModel: DeleteAccountViewModel

    var body: some View {

        VStack(spacing: 0) {

            // Header
            ZStack {
                HStack {
                    Button {
                        viewModel.backTapped()
                    } label: {
                        Image(ImageConstants.backImage)
                    }

                    Spacer()
                }

                ReusableText(
                    title: "delete_account_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    ReusableText(
                        title: "delete_account_subheading",
                        fontSize: 14,
                        fontName: "Livvic-Regular",
                        fontColor: AppColors.grey1
                    )

                    // Warning Card
                    VStack(alignment: .leading, spacing: 8) {

                        BulletText(text: "delete_warning_1")
                        BulletText(text: "delete_warning_2")
                        BulletText(text: "delete_warning_3")
                    }
                    .padding(16)
                    .background(AppColors.grey3)
                    .cornerRadius(12)

                    ReusableText(
                        title: "delete_why_leaving",
                        fontSize: 15,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )

                    LazyVStack(spacing: 10) {

                        ForEach(viewModel.state.reasons) { reason in

                            DeleteReasonRow(
                                title: reason.title,
                                isSelected: viewModel.state.selectedReason?.id == reason.id
                            ) {
                                viewModel.selectReason(reason)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }

            // Bottom Button
            PrimaryButton(
                title: "proceed_title",
                isEnabled: viewModel.state.isProceedEnabled
            ) {
                viewModel.proceedTapped()
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
                Color.black.opacity(0.3).ignoresSafeArea(edges: .vertical)
                ProgressView().tint(.white).scaleEffect(1.5)
            }
        }
        .sheet(isPresented: viewModel.binding(for: \.state.showPasswordSheet)) {
            if #available(iOS 16.4, *) {
                DeletePasswordSheet(viewModel: viewModel)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.white)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


struct BulletText: View {

    let text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 8) {

            Circle()
                .fill(AppColors.textBlack1)
                .frame(width: 4, height: 4)
                .padding(.top, 7)
            ReusableText(
                title: text,
                fontSize: 13,
                fontName: "Livvic-Medium",
                fontColor: AppColors.grey1
            )
        }
    }
}


struct DeleteReasonRow: View {

    let title: LocalizedStringKey
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {

                ReusableText(
                    title: title,
                    fontSize: 14,
                    fontName: "Livvic-Medium",
                    fontColor: AppColors.grey1
                )
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected
                        ? AppColors.primary
                        : Color.gray.opacity(0.15),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
