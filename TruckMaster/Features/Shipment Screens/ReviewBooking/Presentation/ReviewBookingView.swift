//
//  ReviewBookingView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 25/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct ReviewBookingView: View {
    @ObservedObject var viewModel: ReviewBookingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(title: "review_booking_title", fontSize: 18, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Category summary card
                    if viewModel.state.isLoading {
                        VStack(spacing: 12) {
                            ForEach(0..<2, id: \.self) { _ in
                                HStack(spacing: 12) {
                                    Circle().fill(AppColors.grey3).frame(width: 32, height: 32).shimmer()
                                    RoundedRectangle(cornerRadius: 4).fill(AppColors.grey3).frame(width: 120, height: 13).shimmer()
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(AppColors.grey3)
                        .cornerRadius(12)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(Array(viewModel.state.categorySummaries.enumerated()), id: \.element.id) { index, summary in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: summary.image)) { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFit()
                                        } else {
//                                            Color(AppColors.grey3)
                                        }
                                    }
                                    .frame(width: 55, height: 55)
                                    .cornerRadius(6)

                                    Text(summary.name)
                                        .font(.custom("Livvic-Medium", size: 14))
                                        .foregroundColor(AppColors.textBlack1)

                                    Spacer()

                                    Text("\(summary.totalItems) Items")
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
                    }

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
                                    Text(viewModel.state.pickupAddress)
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
                                    Text(viewModel.state.dropAddress)
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
                            ForEach(viewModel.state.extrasLines, id: \.self) { line in
                                Text(line)
                                    .font(.custom("Livvic-Medium", size: 14))
                                    .foregroundColor(AppColors.textBlack1)
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

                    // Terms
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Read before booking")
                            .font(.custom("Livvic-SemiBold", size: 15))
                            .foregroundColor(AppColors.textBlack1)

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.state.termsLines, id: \.self) { line in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("•")
                                        .foregroundColor(AppColors.grey1)
                                    Text(line)
                                        .font(.custom("Livvic-Medium", size: 13))
                                        .foregroundColor(AppColors.grey1)
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 50)
            }
            .scrollIndicators(.hidden)

            PrimaryButton(title: "send_request_title") {
                viewModel.sendRequestTapped()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(isPresented: viewModel.binding(for: \.state.showShedule)) {
            if #available(iOS 16.4, *) {
                SheduleSheet(viewModel: viewModel.makeScheduleViewModel())
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.white)
            }
        }
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .dismissKeyboardOnTap()
    }
}
