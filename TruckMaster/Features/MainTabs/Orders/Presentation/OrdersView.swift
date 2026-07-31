//
//  OrdersView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 10/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct OrdersView: View {

    @StateObject var viewModel: OrdersViewModel

    var body: some View {
        VStack(spacing: 0) {

        
            HStack {
                ReusableText(
                    title: "orders_heading",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )

                Spacer()

                Button {
                    viewModel.notificationTapped()
                } label: {
                    Image(ImageConstants.icNotification)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)

            // MARK: - Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: - Orders List
                    if viewModel.state.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)

                    }  else if viewModel.state.orders.isEmpty {

                        VStack {
                            Spacer()

                            EmptyStateView(
                                image: ImageConstants.emptyOrders,
                                title: "no_orders_found_heading",
                                message: "no_orders_found_subheading"
                            )
                            .padding(.horizontal, 20)

                            Spacer()
                        }
                        .frame(
                            maxWidth: .infinity,
                            minHeight: UIScreen.main.bounds.height * 0.5
                        )
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.state.orders, id: \.id) { order in
                                OrderCard(order: order)
                                    .padding(.horizontal, 20)
                                    .onAppear {
                                        if order.id == viewModel.state.orders.last?.id {
                                            Task { await viewModel.onLoadMore() }
                                        }
                                    }
                            }

                            if viewModel.state.isLoadingMore {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                        }
                    }

                    Spacer(minLength: 120)
                }
            }
            .refreshable {
                await viewModel.onRefresh()
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// MARK: - Order Card
@available(iOS 16.0, *)
private struct OrderCard: View {

    let order: OrderResponse

    var body: some View {
        CardContainer(
            cornerRadius: 16,
            backgroundColor: AppColors.grey3
        ) {
            VStack(alignment: .leading, spacing: 0) {

                // Top Row
                HStack(spacing: 10) {
                    Image(ImageConstants.truckImage1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)

                    ReusableText(
                        title: LocalizedStringKey(order.status),
                        fontSize: 14,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )

                    Spacer()

                    Text(order.status)
                        .font(.custom("Livvic-SemiBold", size: 11))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .cornerRadius(5)
                }
                .padding(.bottom, 10)

                // Tracking + Driver
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        ReusableText(
                            title: "tracking_id_label",
                            fontSize: 12,
                            fontName: "Livvic-Regular",
                            fontColor: AppColors.grey1
                        )

                        Text(String(order.id))
                            .font(.custom("Livvic-SemiBold", size: 13))
                            .foregroundColor(AppColors.textBlack1)

                      
                            HStack(spacing: 4) {
                                ReusableText(
                                    title: "estimated_time_label",
                                    fontSize: 12,
                                    fontName: "Livvic-Regular",
                                    fontColor: AppColors.grey1
                                )
                                Text("15")
                                    .font(.custom("Livvic-SemiBold", size: 12))
                                    .foregroundColor(AppColors.colorYellow)
                            }
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 4) {
                        ReusableText(
                            title: "driver_label",
                            fontSize: 12,
                            fontName: "Livvic-Regular",
                            fontColor: AppColors.grey1
                        )

                        Text("Driver")
                            .font(.custom("Livvic-SemiBold", size: 13))
                            .foregroundColor(AppColors.textBlack1)
                    }
                }
            }
            .padding(16)
        }
    }
}
