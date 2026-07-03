//
//  DeliveredDetailView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/07/26.
//


internal import SwiftUI

@available(iOS 16.0, *)
struct DeliveredDetailView: View {
    @ObservedObject var viewModel: DeliveredDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(title: "ID #123456", fontSize: 18, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
                                    Text("Pick up address")
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
                                    Text("Drop address")
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
                    
                    // Items
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
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Items")
                                .font(.custom("Livvic-SemiBold", size: 16))
                                .foregroundColor(AppColors.textBlack1)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(CategorySummary.dummyList) { summary in
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: summary.image)) { phase in
                                            if let image = phase.image {
                                                image.resizable().scaledToFit()
                                            } else {
//                                                Color(AppColors.grey3)
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
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        }
                        
                        // Extras
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Schedule & Extras")
                                .font(.custom("Livvic-SemiBold", size: 15))
                                .foregroundColor(AppColors.textBlack1)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(viewModel.state.items, id: \.self) { line in
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
                        
                        
                        // Feedback
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Feedback")
                                .font(.custom("Livvic-SemiBold", size: 15))
                                .foregroundColor(AppColors.textBlack1)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                RatingView(rating: 4)
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
                }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 50)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.onAppear()
            }
            .snackbar(
                isShowing: viewModel.binding(for: \.state.showSnackbar),
                message: viewModel.state.snackbarMessage,
                type: viewModel.state.snackbarType
            )
            .dismissKeyboardOnTap()
        }
    }
    

private struct RatingView: View{
     var rating: Int
    var body: some View{
        VStack(spacing: 16) {
            
            
            HStack{
                ForEach(0..<5, id: \.self){ index in
                    Image(index <= rating ? ImageConstants.startFilled : ImageConstants.startEmpty)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.horizontal, 5)
                       
                }
            }
           
                ReusableText(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed egestas neque id interdum porttitor.", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
                
            
        }
        .padding(.horizontal, 40)
    }
}
