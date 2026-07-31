internal import SwiftUI

@available(iOS 16.0, *)
struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 0) {

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    ReusableText(
                        title: "location_title",
                        fontSize: 16,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    .padding(.bottom, 2)

                    HStack(spacing: 4) {
                        Image(ImageConstants.icLocation)

                        Text(viewModel.state.locationName)
                            .font(.custom("Rubik-Regular", size: 14))
                            .foregroundColor(AppColors.grey1)
                    }
                }

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

                    // MARK: - Banners
                    VStack(spacing: 12) {
                        HomeBannerCard(
                            title: "start_new_shipment_heading",
                            backgroundColor: AppColors.colorPink,
                            image: ImageConstants.truckImage
                        ) {
                            viewModel.startNewShipmentTapped()
                        }

                        HomeBannerCard(
                            title: "track_delivery_heading",
                            backgroundColor: AppColors.colorBlue,
                            image: ImageConstants.deliveryBoxImage
                        ) {
                            viewModel.trackDeliveryTapped()
                        }
                    }
                    .padding(.horizontal, 20)

                    // MARK: - Current Shipment
                    if viewModel.state.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)

                    } else if viewModel.state.shipments.isEmpty {
                        EmptyStateView(
                            image: ImageConstants.truckImage,
                            title: "No Shipments",
                            message: "You have no current shipments at the moment.",
                            buttonTitle: "Start New Shipment"
                        ) {
                            viewModel.startNewShipmentTapped()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                    } else {
                        // heading only shows if shipments exist
                        ReusableText(
                            title: "current_shipment_heading",
                            fontSize: 16,
                            fontName: "Livvic-SemiBold",
                            fontColor: AppColors.textBlack1
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 8)

                        VStack(spacing: 12) {
                            ForEach(viewModel.state.shipments, id: \.id) { shipment in
                                CardContainer(
                                    cornerRadius: 16,
                                    backgroundColor: AppColors.grey3
                                ) {
                                    HomeShipmentCardContent(shipment: shipment)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer(minLength: 100)
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
@available(iOS 16.0, *)
private struct HomeBannerCard: View {

    let title: LocalizedStringKey
    let backgroundColor: Color
    let image: String
    let action: () -> Void

    var body: some View {
        CardContainer(
            cornerRadius: 16,
            backgroundColor: backgroundColor,
            height: 130
        ) {
            HStack(spacing: 0) {

                VStack(alignment: .leading, spacing: 12) {
                    ReusableText(
                        title: title,
                        fontSize: 18,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )

                    Image(ImageConstants.rightArrow)
                        .frame(width: 25, height: 12)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .cornerRadius(6)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 120)
                    .padding(.trailing, 8)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

// MARK: - Shipment Card Content
@available(iOS 16.0, *)
private struct HomeShipmentCardContent: View {

    let shipment: ShipmentModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(spacing: 10) {
                Image(ImageConstants.truckImage1)

                VStack(alignment: .leading, spacing: 2) {
                    ReusableText(
                        title: LocalizedStringKey(shipment.type),
                        fontSize: 14,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                    ReusableText(
                        title: LocalizedStringKey("Tracking ID: \(shipment.trackingID)"),
                        fontSize: 12,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.textBlack1
                    )
                }
            }
            .padding(.bottom, 12)

            Divider()
                .padding(.bottom, 12)

            HStack {
                HomeShipmentInfoColumn(
                    label: "from_label",
                    value: LocalizedStringKey(shipment.from)
                )
                Spacer()
                HomeShipmentInfoColumn(
                    label: "shipping_to_label",
                    value: LocalizedStringKey(shipment.to)
                )
            }
            .padding(.bottom, 12)

            HStack {
                HomeShipmentInfoColumn(
                    label: "status_label",
                    value: LocalizedStringKey(shipment.status)
                )
                Spacer()
                HomeShipmentInfoColumn(
                    label: "driver_label",
                    value: LocalizedStringKey(shipment.driver)
                )
            }
        }
        .padding(16)
    }
}

// MARK: - Shipment Info Column
private struct HomeShipmentInfoColumn: View {

    let label: LocalizedStringKey
    let value: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ReusableText(
                title: label,
                fontSize: 14,
                fontName: "Livvic-Medium",
                fontColor: AppColors.textBlack1
            )
            ReusableText(
                title: value,
                fontSize: 14,
                fontName: "Livvic-Medium",
                fontColor: AppColors.grey1
            )
        }
    }
}
