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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    // Address
                    VStack(alignment: .leading, spacing: 10) {
                        ReusableText(title: "address_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                        
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 5) {
                                VStack(spacing: 0) {
                                    Image(ImageConstants.greenDot)
                                        .padding(.vertical, 8)

                                    Image(ImageConstants.line)
                                        .padding(.bottom, 8)

                                    Image(ImageConstants.location)
                                        .padding(.bottom, 8)
                                      
                                    
                                }
                                VStack(spacing: 16) {

                                    // Pickup
                                    HStack(alignment: .top, spacing: 12) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack(spacing: 4) {
                                                Text("Sender name")
                                                    .font(.custom("Livvic-SemiBold", size: 14))
                                                    .foregroundColor(AppColors.textBlack1)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .layoutPriority(0)

//                                                if !viewModel.state.pickupPhone.isEmpty {
//                                                    Text("• \(viewModel.state.pickupPhone)")
                                                    Text("• 1234567898")
                                                        .font(.custom("Livvic-Regular", size: 13))
                                                        .foregroundColor(AppColors.grey1)
                                                        .lineLimit(1)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .layoutPriority(1)
//                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            Text("Pick up address")
                                                .font(.custom("Livvic-Regular", size: 13))
                                                .foregroundColor(AppColors.grey1)
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(14)
                                    .background(AppColors.grey3)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                    )

                                    // Drop location
                                    HStack(alignment: .top, spacing: 12) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack(spacing: 4) {
                                                
                                                Text("Receiver name")
                                                    .font(.custom("Livvic-SemiBold", size: 14))
                                                    .foregroundColor(AppColors.textBlack1)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                    .layoutPriority(0)
                                               
                                                    Text("• 9876543267")
                                                        .font(.custom("Livvic-Regular", size: 13))
                                                        .foregroundColor(AppColors.grey1)
                                                        .lineLimit(1)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .layoutPriority(1)
                                                
                                                
                                            }
                                            Text("Drop address")
                                                .font(.custom("Livvic-Regular", size: 13))
                                                .foregroundColor(AppColors.grey1)
                                                .lineLimit(1)
                                        }

                                        Spacer()
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
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 20)
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
                            
                            ReusableText(title: "items_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                            
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
                            ReusableText(title: "schedule_extra_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                HStack(spacing: 10){
                                    HStack(spacing: 5){
                                        Image(ImageConstants.date)
                                        ReusableText(title: "02/04/2025", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 5){
                                        Image(ImageConstants.time)
                                        ReusableText(title: "15:00", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
                                        
                                    }
                                    
                                    Spacer()
                                }
                                
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
    
                            ReusableText(title: "feedback_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                                RatingView(rating: 3)
                                 ReusableText(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed egestas neque id interdum porttitor.", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
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
                        
                        
                        // Company & Fare
                        VStack(alignment: .leading, spacing: 10) {
    
                            ReusableText(title: "company_fare_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                               
                                HStack(alignment: .center, spacing: 12) {
                                    
                                    Image(ImageConstants.driverAlert)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Company name")
                                            .font(.custom("Livvic-Medium", size: 14))
                                            .foregroundColor(AppColors.textBlack1)
                                        
                                        HStack(spacing: 8) {

                                                HStack(spacing: 2) {
                                                    Image(systemName: "star.fill")
                                                        .font(.system(size: 11))
                                                        .foregroundColor(.yellow)
                                                    Text("4.5")
                                                        .font(.custom("Livvic-Medium", size: 13))
                                                        .foregroundColor(AppColors.grey1)
                                                }
                                          
                                        }
                                    }
                                    
                                    Spacer()
                                
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(AppColors.grey3)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                        }
                        
                        
                        
                        // Price breakdown
                        VStack(alignment: .leading, spacing: 10) {
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10){
                                    
                                    ReusableText(title: "price_breakup_title", fontSize: 13, fontName: "Livvic-Medium", fontColor: AppColors.grey1)
                                    
                                    Spacer()
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.priceBreakUpTapped()
                                        }} label: {
                                        Image(systemName: viewModel.state.isPriceDetailVisible ? "chevron.up" : "chevron.down")
                                    }
                                }
                                
                                if  viewModel.state.isPriceDetailVisible {
                                    VStack(alignment: .leading, spacing: 10) {
                                        VStack(spacing: 10) {
                                          
                                            PriceRows(label: "8 Km distance", value: 12.8)
                                            
                                            PriceRows(label: "2 helpers", value: 5.7)
                                            PriceRows(label: "Tax", value: 2.0)
                                        }
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
                        
                        // Payment done
                        VStack(alignment: .leading, spacing: 10) {
    
                            VStack(alignment: .leading, spacing: 10) {
                          
                                 ReusableText(title: "Payment is done through cash", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(14)
                            .background(AppColors.colorBlue2)
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
                        .padding(.bottom, 30)
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
                    Image(index < rating ? ImageConstants.startFilled : ImageConstants.startEmpty)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.horizontal, 2)
                       
                }
            }
           
                
            
        }
        .padding(.horizontal, 40)
    }
}

private struct PriceRows: View {
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
