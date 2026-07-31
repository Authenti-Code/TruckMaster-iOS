//
//  SearchCompanyView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 30/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SearchCompanyView: View {
    @ObservedObject var viewModel: PickupLocationViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack {

                PickupLocationMapView(
                    coordinate: viewModel.state.coordinate,
                    profileImage: viewModel.state.profileImage
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack(spacing: 12) {
                        Button { viewModel.backTapped() } label: {
                            Image(ImageConstants.backImage)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geo.safeAreaInsets.top + 12)

                    Spacer()

                    VStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 16) {

                            ReusableText(
                                title: "search_company_title",
                                fontSize: 16,
                                fontName: "Livvic-SemiBold",
                                fontColor: AppColors.textBlack1
                            )

                            if viewModel.state.isSearching {
                                HStack {
                                    Spacer()
                                    Image(ImageConstants.truckImage2)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Spacer()
                                }

                                ReusableText(
                                    title: "searching_title",
                                    fontSize: 16,
                                    fontName: "Livvic-Medium",
                                    fontColor: AppColors.grey1
                                )
                                .frame(maxWidth: .infinity, alignment: .center)

                            } else if viewModel.state.offers.isEmpty {
                                HStack {
                                    Spacer()
                                    Image(ImageConstants.truckImage2)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Spacer()
                                }

                                ReusableText(
                                    title: "no_company_found_title",
                                    fontSize: 16,
                                    fontName: "Livvic-Medium",
                                    fontColor: AppColors.grey1
                                )
                                .frame(maxWidth: .infinity, alignment: .center)

                            } else {
                                ScrollView {
                                    VStack(spacing: 12) {
                                        VStack(spacing: 12) {
                                            ForEach(
                                                Array(viewModel.state.offers.prefix(viewModel.state.visibleCount)),
                                                id: \.company.id
                                            ) { company in
                                                CompanyCardView(offer: company) {
                                                    viewModel.companyTapped(company)
                                                }
                                            }
                                        }
                                    }
                                    .animation(.easeOut(duration: 0.3), value: viewModel.state.visibleCount)
                                    .padding(.top, 4)
                                    .padding(.bottom, 12)
                                }
                                .frame(maxHeight: 320) 
                                .scrollIndicators(.hidden)
                            }

                            PrimaryDanger(title: "cancel_title") {
                                viewModel.backTapped()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                        .background(Color.white)
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .overlay(
                            RoundedCorner(radius: 24, corners: [.topLeft, .topRight])
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
    }
}

private struct CompanyCardView: View {
    let offer: ActiveOrderOffer
    let onTap: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            HStack(alignment: .center, spacing: 12) {
                
                Image(ImageConstants.driverAlert)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(offer.company.companyName)
                        .font(.custom("Livvic-Medium", size: 14))
                        .foregroundColor(AppColors.textBlack1)
                    
                    HStack(spacing: 8) {
                        if let rating = offer.company.id.isMultiple(of: 2) ? nil : "4.8" {
                      
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.yellow)
                                Text(rating)
                                    .font(.custom("Livvic-Medium", size: 13))
                                    .foregroundColor(AppColors.grey1)
                            }
                        }
                    
                      
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(offer.price)")
                        .font(.custom("Livvic-SemiBold", size: 16))
                        .foregroundColor(AppColors.textBlack1)
                    
                    if let time = offer.respondedAt {
                        Text("\(time)")
                            .font(.custom("Livvic-Medium", size: 13))
                            .foregroundColor(AppColors.grey1)
                    }
                }
            }
            Divider()
            
            HStack{
                Spacer()
                Button { onTap() } label: {
                    ReusableText(
                        title: "view_details_title",
                        fontSize: 14,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.textBlack1
                    )
                    Image(systemName: "chevron.right")
                }
                Spacer()
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
