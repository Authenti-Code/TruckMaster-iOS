//
//  EnRouteView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct EnRouteView: View {
    @ObservedObject var viewModel: EnRouteViewModel

    var body: some View {
        VStack(spacing: 0) {

            // Nav Bar
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(
                    title: "track_delivery_heading",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            // Segmented tab
            EnRouteTabBar(selected: viewModel.state.selectedTab) { tab in
                viewModel.tabChanged(tab)
            }
            .padding(.bottom, 16)

            // Content
            if viewModel.state.isLoading {
                skeletonView
            } else if viewModel.state.filteredOrders.isEmpty {
                Spacer()
                EmptyStateView(
                    image: ImageConstants.noSavedAddress,
                    title: viewModel.state.selectedTab == .enRoute
                        ? "no_enroute_orders_heading"
                        : "no_delivered_orders_heading",
                    message: viewModel.state.selectedTab == .enRoute
                        ? "no_enroute_orders_subheading"
                        : "no_delivered_orders_subheading"
                )
                .padding(.horizontal, 20)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.state.filteredOrders) { order in
                            OrderTrackingCard(order: order)
                                .onTapGesture { viewModel.orderTapped(order) }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
    }

    private var skeletonView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { _ in
                    SavedAddressSkeletonCard()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Tab enum
enum EnRouteTab {
    case enRoute, delivered
}

// MARK: - Segmented tab bar
@available(iOS 16.0, *)
private struct EnRouteTabBar: View {
    let selected: EnRouteTab
    let onSelect: (EnRouteTab) -> Void

    var body: some View {
        HStack(spacing: 0) {
            TabPill(title: "En-route", isSelected: selected == .enRoute) {
                withAnimation(.easeInOut(duration: 0.2)) { onSelect(.enRoute) }
            }
            TabPill(title: "Delivered", isSelected: selected == .delivered) {
                withAnimation(.easeInOut(duration: 0.2)) { onSelect(.delivered) }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(AppColors.colorSkin)
    }
}

private struct TabPill: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            Text(title)
                .font(.custom("Livvic-Medium", size: 14))
                .foregroundColor(isSelected ? AppColors.textBlack1 : AppColors.grey1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color.white : Color.clear)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Order tracking card
private struct OrderTrackingCard: View {
    let order: ShipmentModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 10) {
                Image(ImageConstants.orderBox)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)

                Text(order.type)
                    .font(.custom("Livvic-SemiBold", size: 16))
                    .foregroundColor(AppColors.textBlack1)

                Spacer()

                if order.status == "Delivered"
                {
                    VStack{
                        Text(order.status)
                            .font(.custom("Livvic-SemiBold", size: 11))
                            .foregroundColor(AppColors.colorGreen1)
                            .padding(5)
                    }
                    .background(AppColors.colorGreen)
                }
                
                if order.status != "Delivered"{
                    Image(ImageConstants.rightArrowS)
                }
            }

            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tracking ID:")
                        .font(.custom("Livvic-Regular", size: 13))
                        .foregroundColor(AppColors.grey1)
                    Text(order.trackingID)
                        .font(.custom("Livvic-SemiBold", size: 14))
                        .foregroundColor(AppColors.textBlack1)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Driver:")
                        .font(.custom("Livvic-Regular", size: 13))
                        .foregroundColor(AppColors.grey1)
                    Text(order.driver)
                        .font(.custom("Livvic-SemiBold", size: 14))
                        .foregroundColor(AppColors.textBlack1)
                }
            }

            if let estimatedTime = order.estimatedTime {
                HStack(spacing: 4) {
                    Text("Estimated time:")
                        .font(.custom("Livvic-Regular", size: 13))
                        .foregroundColor(AppColors.grey1)
                    Text(estimatedTime)
                        .font(.custom("Livvic-SemiBold", size: 13))
                        .foregroundColor(AppColors.colorYellow)
                }
            }
        }
        .padding(16)
        .background(AppColors.grey3)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}
