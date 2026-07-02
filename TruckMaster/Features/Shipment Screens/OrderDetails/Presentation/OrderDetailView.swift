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
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if let order = viewModel.state.order {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Category summary
                        VStack(spacing: 0) {
                            ForEach(Array(order.items.enumerated()), id: \.offset) { index, item in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: item.categoryImage ?? "")) { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFit()
                                        } else {
//                                            Color(AppColors.grey3)
                                        }
                                    }
                                    .frame(width: 55, height: 55)
                                    .cornerRadius(6)

                                    Text(item.categoryName ?? "Category \(item.categoryId)")
                                        .font(.custom("Livvic-Medium", size: 14))
                                        .foregroundColor(AppColors.textBlack1)

                                    Spacer()

                                    Text("\(item.quantity ?? 0) Items")
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
                            Text("Address")
                                .font(.custom("Livvic-SemiBold", size: 16))
                                .foregroundColor(AppColors.textBlack1)

                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top, spacing: 10) {
                                    VStack(spacing: 0) {
                                        Circle().fill(Color.green).frame(width: 8, height: 8)
                                            .padding(.top, 12)
                                        Rectangle().fill(Color.gray.opacity(0.3)).frame(width: 1).frame(maxHeight: .infinity)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("From")
                                            .font(.custom("Livvic-Medium", size: 14))
                                            .foregroundColor(AppColors.grey1)
                                        Text(order.pickupAddress.address)
                                            .font(.custom("Livvic-Medium", size: 14))
                                            .foregroundColor(AppColors.textBlack1)
                                    }
                                }

                                HStack(alignment: .top, spacing: 10) {
                                    Circle().fill(Color.red).frame(width: 8, height: 8)
                                        .padding(.top, 12)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Shipping to")
                                            .font(.custom("Livvic-Regular", size: 13))
                                            .foregroundColor(AppColors.grey1)
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
                            Text("Extras")
                                .font(.custom("Livvic-SemiBold", size: 15))
                                .foregroundColor(AppColors.textBlack1)

                            VStack(alignment: .leading, spacing: 8) {
                                let extras = order.extras
                                if extras.helpers > 0 {
                                    Text("\(extras.helpers) Helper\(extras.helpers == 1 ? "" : "s")")
                                        .font(.custom("Livvic-Medium", size: 14))
                                        .foregroundColor(AppColors.textBlack1)
                                }
                                if extras.fragileHandling { extraRow("Fragile Handling") }
                                if extras.stairsCarry     { extraRow("Stairs Carry") }
                                if extras.urgent          { extraRow("Urgent") }
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
                        if let offer = order.companyOffer {
                            Text("Company Offers")
                                .font(.custom("Livvic-SemiBold", size: 16))
                                .foregroundColor(AppColors.textBlack1)
                            VStack(alignment: .leading, spacing: 12){
                              
                                
                                HStack(alignment: .center, spacing: 12) {
                                    
                                    Image(ImageConstants.driverAlert)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(offer.companyName)
                                            .font(.custom("Livvic-Medium", size: 14))
                                            .foregroundColor(AppColors.textBlack1)
                                        
                                        HStack(spacing: 8) {
                                            if let rating = offer.rating {
                                                HStack(spacing: 2) {
                                                    Image(systemName: "star.fill")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.yellow)
                                                    
                                                    Text(rating)
                                                        .font(.custom("Livvic-Medium", size: 13))
                                                        .foregroundColor(AppColors.grey1)
                                                    
                                                    Divider()
                                                        .frame(width: 2)
                                                        .frame(maxHeight: 20)
                                                    
                                                    if let truckType = offer.truckType {
                                                        Text(truckType)
                                                            .font(.custom("Livvic-Medium", size: 13))
                                                            .foregroundColor(AppColors.grey1)
                                                    }
                                                  
                                                }
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("$\(offer.totalPrice)")
                                            .font(.custom("Livvic-SemiBold", size: 16))
                                            .foregroundColor(AppColors.textBlack1)
                                        
                                        if let time = offer.estimatedTime {
                                            Text("\(time)")
                                                .font(.custom("Livvic-Medium", size: 13))
                                                .foregroundColor(AppColors.grey1)
                                        }
                                    }
                                }
                                if let breakdown = order.priceBreakdown {
                                    VStack(alignment: .leading, spacing: 10) {
                                        
                                        Divider()
                                        
                                        Text("Price Breakup:")
                                            .font(.custom("Livvic-Medium", size: 13))
                                            .foregroundColor(AppColors.grey1)

                                        VStack(spacing: 10) {
                                            if let label = breakdown.distanceLabel {
                                                PriceRow(label: label, value: breakdown.distancePrice)
                                            }
                                            PriceRow(label: "\(order.extras.helpers) helpers", value: breakdown.helpersPrice)
                                            PriceRow(label: "Tax", value: breakdown.tax)
                                        }
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
                        Text("Reject")
                            .font(.custom("Livvic-SemiBold", size: 16))
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
                        Text("Accept")
                            .font(.custom("Livvic-SemiBold", size: 16))
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
