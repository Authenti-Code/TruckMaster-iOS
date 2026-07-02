//
//  NotificationView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct NotificationView: View {
    @ObservedObject var viewModel: NotificationViewModel

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
                    title: "notifications_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            if viewModel.state.isLoading {
                skeletonView
            } else if viewModel.state.notifications.isEmpty {
                Spacer()
                EmptyStateView(
                    image: ImageConstants.noNotificaitons,
                    title: "no_notifications_title",
                    message: "no_notifications_subheading"
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.state.notifications) { notification in
                            NotificationCardView(notification: notification)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 12)
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    await viewModel.onRefresh()
                }
            }
        }
        .frame(maxHeight: .infinity)
        .navigationBarHidden(true)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .onAppear { viewModel.onAppear() }
    }

    // MARK: - Skeleton
    private var skeletonView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<10, id: \.self) { _ in
                    NotificationSkeletonCard()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 12)
        }
        .scrollIndicators(.hidden)
    }
}

private struct NotificationCardView: View {
    let notification: NotificationModel

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if let icon = notification.icon {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.custom("Livvic-SemiBold", size: 15))
                    .foregroundColor(AppColors.textBlack1)

                Text(notification.message)
                    .font(.custom("Livvic-Regular", size: 13))
                    .foregroundColor(AppColors.grey1)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}

private struct NotificationSkeletonCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Circle()
                .fill(AppColors.grey3)
                .frame(width: 32, height: 32)
                .shimmer()

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.grey3)
                    .frame(width: 100, height: 13)
                    .shimmer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.grey3)
                    .frame(width: 180, height: 11)
                    .shimmer()
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)
        )
    }
}
