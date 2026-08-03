//
//  OrderDetailView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 01/07/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct OrderDetailView: View {
    @ObservedObject var viewModel: OrderDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(title: "order_detail_title", fontSize: 18, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            if viewModel.state.isLoading {
                ScrollView {
                        OrderDetailSkeletonView()
                    }
                    .scrollIndicators(.hidden)
            } else if let order = viewModel.state.order {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Category summary
                        VStack(spacing: 0) {
                            ForEach(Array(order.orderItems.enumerated()), id: \.offset) { index, item in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: item.category.image ?? "")) { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFit()
                                        } else {
//                                            Color(AppColors.grey3)
                                        }
                                    }
                                    .frame(width: 55, height: 55)
                                    .cornerRadius(6)

                                    Text(item.category.name)
                                        .font(.custom("Livvic-Medium", size: 14))
                                        .foregroundColor(AppColors.textBlack1)

                                    Spacer()

                                    Text("\(item.category.quantity) Items")
                                        .font(.custom("Livvic-Medium", size: 13))
                                        .foregroundColor(AppColors.primary)

                                    Image(ImageConstants.rightArrowS)
                                }
                                .padding(.vertical, 12)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .background(AppColors.grey3)
                        .cornerRadius(12)

                        // Address
                        VStack(alignment: .leading, spacing: 10) {

                            ReusableText(title: "address_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)

                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top, spacing: 10) {
                                    VStack(spacing: 0) {
                                        Circle().fill(Color.green).frame(width: 8, height: 8)
                                            .padding(.top, 12)
                                        Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 1).frame(maxHeight: .infinity)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {

                                         ReusableText(title: "from_title", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.grey1)

                                        Text(order.pickupAddress.address)
                                            .font(.custom("Livvic-Medium", size: 14))
                                            .foregroundColor(AppColors.textBlack1)
                                    }
                                }

                                HStack(alignment: .top, spacing: 10) {
                                    Circle().fill(Color.red).frame(width: 8, height: 8)
                                        .padding(.top, 12)
                                    VStack(alignment: .leading, spacing: 2) {

                                         ReusableText(title: "shipping_to_label", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.grey1)

                                        Text(order.dropAddress.address)
                                            .font(.custom("Livvic-Medium", size: 14))
                                            .foregroundColor(AppColors.textBlack1)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        }

                        // Extras
                        VStack(alignment: .leading, spacing: 10) {

                            ReusableText(title: "extras_title", fontSize: 15, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)

                            VStack(alignment: .leading, spacing: 8) {
                                let extras = order.orderExtra
                                if extras.helpers > 0 {
                                    Text("\(extras.helpers) Helper\(extras.helpers == 1 ? "" : "s")")
                                        .font(.custom("Livvic-Medium", size: 14))
                                        .foregroundColor(AppColors.textBlack1)
                                }
                                if extras.fragileHandling { extraRow("Fragile Handling") }
                                if extras.stairsCarry     { extraRow("Stairs Carry") }
                                if extras.zipHandler      { extraRow("Zip Handler") }
                                extraRow(extras.elevator ? "Elevator: Yes" : "Elevator: No")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        }

                        // Company Offer
                        ReusableText(title: "company_offers_title", fontSize: 15, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)

                        VStack(alignment: .leading, spacing: 12) {

                            HStack(alignment: .center, spacing: 12) {

                                Image(ImageConstants.driverAlert)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(order.company.companyName)
                                        .font(.custom("Livvic-Medium", size: 14))
                                        .foregroundColor(AppColors.textBlack1)

                                    // rating / truckType / estimatedTime are not present
                                    // in the /order/offer/details response — removed until
                                    // the API adds them, or wire from another source if available.
                                    if let respondedAt = order.respondedAt {
                                        Text(respondedAt.relativeTimeAgo)
                                            .font(.custom("Livvic-Medium", size: 13))
                                            .foregroundColor(AppColors.grey1)
                                    }
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("$\(order.price)")
                                        .font(.custom("Livvic-SemiBold", size: 16))
                                        .foregroundColor(AppColors.textBlack1)
                                }
                            }

                            VStack(alignment: .leading, spacing: 10) {

                                Divider()

                                Text("Price Breakup:")
                                    .font(.custom("Livvic-Medium", size: 13))
                                    .foregroundColor(AppColors.grey1)

                                VStack(spacing: 10) {
                                    PriceRow(label: "Truck Charges", value: order.priceBreakdown.truckCharges)
                                    PriceRow(label: "\(order.orderExtra.helpers) helpers", value: order.priceBreakdown.helperCharges)
                                    PriceRow(label: "Tax", value: order.priceBreakdown.taxCharges)
                                }
                            }
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
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 50)
                }
                .scrollIndicators(.hidden)
            }

            HStack(spacing: 12) {
                Button { viewModel.rejectTapped() } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark")
                        ReusableText(title: "reject_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: .white)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.colorRed2)
                    .clipShape(Capsule())
                }

                Button { viewModel.acceptTapped() } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark")
                        ReusableText(title: "accept_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: .white)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.colorGreen1)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
    }

    private func extraRow(_ text: String) -> some View {
        Text(text)
            .font(.custom("Livvic-Medium", size: 14))
            .foregroundColor(AppColors.textBlack1)
    }
}

private struct PriceRow: View {
    let label: String
    let value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Livvic-Regular", size: 14))
                .foregroundColor(AppColors.grey1)
            Spacer()
            Text("$\(String(format: "%.2f", value))")
                .font(.custom("Livvic-Medium", size: 14))
                .foregroundColor(AppColors.textBlack1)
        }
    }
}

struct ShimmerBlock: View {
    var width: CGFloat? = nil
    var height: CGFloat = 14
    var cornerRadius: CGFloat = 6

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(AppColors.grey3)
            .frame(width: width, height: height)
            .modifier(ShimmerModifier())
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}

private struct OrderDetailSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Category summary skeleton
            VStack(spacing: 0) {
                ForEach(0..<2, id: \.self) { _ in
                    HStack(spacing: 12) {
                        ShimmerBlock(width: 55, height: 55, cornerRadius: 6)
                        ShimmerBlock(width: 120, height: 14)
                        Spacer()
                        ShimmerBlock(width: 50, height: 12)
                    }
                    .padding(.vertical, 12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .background(AppColors.grey3.opacity(0.3))
            .cornerRadius(12)

            // Address skeleton
            VStack(alignment: .leading, spacing: 10) {
                ShimmerBlock(width: 90, height: 16)

                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 10) {
                        Circle().fill(AppColors.grey3).frame(width: 8, height: 8).modifier(ShimmerModifier())
                        VStack(alignment: .leading, spacing: 6) {
                            ShimmerBlock(width: 60, height: 12)
                            ShimmerBlock(width: 200, height: 14)
                        }
                    }
                    HStack(alignment: .top, spacing: 10) {
                        Circle().fill(AppColors.grey3).frame(width: 8, height: 8).modifier(ShimmerModifier())
                        VStack(alignment: .leading, spacing: 6) {
                            ShimmerBlock(width: 90, height: 12)
                            ShimmerBlock(width: 200, height: 14)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
            }

            // Extras skeleton
            VStack(alignment: .leading, spacing: 10) {
                ShimmerBlock(width: 70, height: 15)

                VStack(alignment: .leading, spacing: 8) {
                    ShimmerBlock(width: 130, height: 14)
                    ShimmerBlock(width: 110, height: 14)
                    ShimmerBlock(width: 90, height: 14)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
            }

            // Company offer skeleton
            ShimmerBlock(width: 130, height: 15)

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 12) {
                    Circle().fill(AppColors.grey3).frame(width: 48, height: 48).modifier(ShimmerModifier())

                    VStack(alignment: .leading, spacing: 6) {
                        ShimmerBlock(width: 100, height: 14)
                        ShimmerBlock(width: 60, height: 12)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 6) {
                        ShimmerBlock(width: 50, height: 16)
                    }
                }

                Divider()

                ShimmerBlock(width: 90, height: 13)

                VStack(spacing: 10) {
                    ShimmerBlock(height: 14)
                    ShimmerBlock(height: 14)
                    ShimmerBlock(height: 14)
                }
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
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 50)
    }
}
