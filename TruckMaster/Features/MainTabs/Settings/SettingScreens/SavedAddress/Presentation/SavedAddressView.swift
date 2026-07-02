//
//  SavedAddressView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SavedAddressView: View {

    @ObservedObject var viewModel: SavedAddressViewModel

    var body: some View {
        ZStack(alignment: .bottom) {

            VStack(spacing: 0) {

                // Nav Bar
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }

                    Spacer()

                    ReusableText(
                        title: "saved_address_heading",
                        fontSize: 18,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )

                    Spacer()

                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                // Content
                if viewModel.state.isLoading {
                    skeletonView
                } else if viewModel.state.addresses.isEmpty {
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
                            ForEach(viewModel.state.addresses) { address in
                                SavedAddressCardView(
                                    address: address,
                                    onEdit: { viewModel.editAddressTapped(address) },
                                    onDelete: { viewModel.deleteAddressTapped(address) }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                    .scrollIndicators(.hidden)
                }
            }

            Button { viewModel.addAddressTapped() } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                              
                                ReusableText(
                                    title: "add_address_title",
                                    fontSize: 15,
                                    fontName: "Livvic-SemiBold",
                                    fontColor: .white
                                )
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: 200)
                            .frame(height: 52)
                            .background(AppColors.primary)
                            .clipShape(Capsule())
                            .padding(.horizontal, 40)
                            .padding(.bottom, 16)
                        }
            
        }
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

// MARK: - Skeleton Card

@available(iOS 16.0, *)
struct SavedAddressCardView: View {

    let address: SavedAddressModel
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            HStack(spacing: 12) {
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
                        .font(.custom("Livvic-SemiBold", size: 15))
                        .foregroundColor(AppColors.textBlack1)

                    HStack(spacing: 4) {
                        Text(address.name)
                            .font(.custom("Livvic-Regular", size: 13))
                            .foregroundColor(AppColors.grey1)

                        if let phone = address.phoneNumber {
                            Text("•")
                                .foregroundColor(AppColors.grey1)
                            Text(phone)
                                .font(.custom("Livvic-Regular", size: 13))
                                .foregroundColor(AppColors.grey1)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    Button(action: onEdit) {
                        Image(ImageConstants.edit)
                       
                    }

                    Button(action: onDelete) {
                        Image(ImageConstants.trash)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)


            // Address
            Text(address.address)
                .font(.custom("Livvic-Medium", size: 14))
                .foregroundColor(AppColors.grey1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(AppColors.grey3)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .multilineTextAlignment(.leading)
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }

    private var iconName: String {
        switch address.label.lowercased() {
        case "home": return ImageConstants.homeAddressSelected
        case "shop": return ImageConstants.shopAddressSelected
        case "other": return ImageConstants.otherAddressSelected
        default:     return "mappin.circle.fill"
        }
    }
}
