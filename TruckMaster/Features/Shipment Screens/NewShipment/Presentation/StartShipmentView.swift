//
//  StartShipmentView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//


internal import SwiftUI

@available(iOS 16.0, *)
struct StartShipmentView: View {
    @ObservedObject var viewModel: StartShipmentViewModel

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
                    title: "start_new_shipment_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack(spacing: 10) {
                
                VStack(spacing: 0){
                    Image(ImageConstants.greenDot)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    Image(ImageConstants.line)
                        .padding(.bottom, 8)
                    
                    Image(ImageConstants.location)
                        .padding(.bottom, 8)
                }
                
                VStack(spacing: 16){
                // Pickup
                    if viewModel.state.isLoading {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.grey2)
                                    .frame(width: 140, height: 13)
                                    .shimmer()

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(AppColors.grey2)
                                    .frame(width: 200, height: 11)
                                    .shimmer()
                            }

                            Spacer()

                            Image(ImageConstants.rightArrowS)
                                .opacity(0.3)
                        }
                        .padding(14)
                        .background(AppColors.grey3)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                        )
                    }
                    else {
                        Button { viewModel.pickupTapped() } label: {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack(spacing: 4) {
                                        Text(viewModel.state.pickupName)
                                            .font(.custom("Livvic-SemiBold", size: 14))
                                            .foregroundColor(AppColors.textBlack1)
                                        if !viewModel.state.pickupPhone.isEmpty {
                                            Text("• \(viewModel.state.pickupPhone)")
                                                .font(.custom("Livvic-Regular", size: 13))
                                                .foregroundColor(AppColors.grey1)
                                        }
                                    }
                                    Text(viewModel.state.pickupAddress)
                                        .font(.custom("Livvic-Regular", size: 13))
                                        .foregroundColor(AppColors.grey1)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                Image(ImageConstants.rightArrowS)
                            }
                            .padding(14)
                            .background(AppColors.grey3)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        }
                    }

                
                // Drop location
                Button { viewModel.dropLocationTapped() } label: {
                    HStack(spacing: 12) {
                        
                        Text(viewModel.state.dropAddress.isEmpty
                                               ? "drop_location_placeholder"
                                               : "drop_location_placeholder")
                                          .font(.custom("Livvic-Regular", size: 14))
                                          .foregroundColor(
                                              viewModel.state.dropAddress.isEmpty
                                              ? AppColors.grey1
                                              : AppColors.textBlack1
                                          )
                                          .lineLimit(1)
                        
                        Spacer()
                        Divider()
                            .frame(height: 25)
                       
                        Image(ImageConstants.icDropLocation)
                         
                    }
                    .padding(14)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                }
            }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1))
            .padding(.horizontal, 20)
            
            // Saved addresses
            VStack(alignment: .leading, spacing: 12) {
                ReusableText(
                    title: "your_saved_address_title",
                    fontSize: 16,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)
                

            ScrollView {
                VStack(alignment: .leading) {

                   

                        VStack(spacing: 0) {
                            if viewModel.state.isLoading {
                                skeletonView
                            } else if viewModel.state.savedAddresses.isEmpty {
                                Spacer()
                                EmptyStateView(
                                    image: ImageConstants.noSavedAddress,
                                    title: "no_address_found_heading",
                                    message: "no_address_found_subheading"
                                )
                                .padding(.horizontal, 20)
                                .padding(.bottom, 100)
                                Spacer()
                            } else {
                                ScrollView {
                                    VStack(spacing: 16) {
                                        ForEach(viewModel.state.savedAddresses) { address in
                                            SavedAddressRow(address: address)
                                        }
                                    }
                                    .padding(.bottom, 100)
                                }
                                .scrollIndicators(.hidden)
                            }
                        }
                    }
                }
                .padding(.bottom, 40)

            }
            .scrollIndicators(.hidden)
        }
        .navigationBarHidden(true)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .onAppear { viewModel.onAppear() }
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

@available(iOS 16.0, *)
struct SavedAddressRow: View {

    let address: SavedAddressModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            HStack(alignment: .top, spacing: 12) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(5)
                    .background(
                        Circle()
                            .fill(AppColors.grey3)
                    )
                    .frame(width: 44, height: 44)
                    
                

                VStack(alignment: .leading, spacing: 2) {
                    Text(address.label.capitalized)
                        .font(.custom("Livvic-SemiBold", size: 14))
                        .foregroundColor(AppColors.textBlack1)

                    HStack(spacing: 4) {
                        Text(address.name)
                            .font(.custom("Livvic-Medium", size: 13))
                            .foregroundColor(AppColors.grey1)

                        if let phone = address.phoneNumber {
                            Text("•")
                                .foregroundColor(AppColors.grey1)
                            Text(phone)
                                .font(.custom("Livvic-Medium", size: 13))
                                .foregroundColor(AppColors.grey1)
                        }
                    }
                    
                    Text(address.address)
                        .font(.custom("Livvic-Medium", size: 13))
                        .foregroundColor(AppColors.grey1)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        Divider()
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }

    private var iconName: String {
        switch address.label.lowercased() {
        case "home": return ImageConstants.homeAddressSelected
        case "shop": return ImageConstants.shopAddressSelected
        case "other": return ImageConstants.otherAddressSelected
        default:     return ImageConstants.location
        }
    }
}
