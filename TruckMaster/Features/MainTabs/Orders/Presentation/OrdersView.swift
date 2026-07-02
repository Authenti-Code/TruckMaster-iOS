//
//  OrdersView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 10/06/26.
//
//
//  OrdersView.swift
//  TruckMaster
//

internal import SwiftUI

@available(iOS 16.0, *)
struct OrdersView: View {

    @StateObject var viewModel: OrdersViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: - Header
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
                            minHeight: UIScreen.main.bounds.height * 0.6
                        )
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.state.orders) { order in
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
            .navigationBarHidden(true)
            .scrollIndicators(.hidden)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// MARK: - Order Card
@available(iOS 16.0, *)
private struct OrderCard: View {

    let order: OrderModel

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
                        title: LocalizedStringKey(order.type),
                        fontSize: 14,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )

                    Spacer()

                    Text(order.status.label)
                        .font(.custom("Livvic-SemiBold", size: 11))
                        .foregroundColor(order.status.textColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(order.status.backgroundColor)
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

                        Text(order.trackingID)
                            .font(.custom("Livvic-SemiBold", size: 13))
                            .foregroundColor(AppColors.textBlack1)

                        if let time = order.estimatedTime {
                            HStack(spacing: 4) {
                                ReusableText(
                                    title: "estimated_time_label",
                                    fontSize: 12,
                                    fontName: "Livvic-Regular",
                                    fontColor: AppColors.grey1
                                )
                                Text(time)
                                    .font(.custom("Livvic-SemiBold", size: 12))
                                    .foregroundColor(AppColors.colorYellow)
                            }
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

                        Text(order.driver)
                            .font(.custom("Livvic-SemiBold", size: 13))
                            .foregroundColor(AppColors.textBlack1)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        let repo    = OrdersRepositoryImpl(apiClient: APIClient())
        let useCase = GetOrdersUseCase(repository: repo)
        OrdersView(viewModel: OrdersViewModel(
            getOrdersUseCase: useCase,
            router: AppRouter()
        ))
    } else { }
}
