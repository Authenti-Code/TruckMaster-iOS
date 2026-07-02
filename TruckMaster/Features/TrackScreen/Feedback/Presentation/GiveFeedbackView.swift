//
//  GiveFeedbackView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 02/07/26.
//
internal import SwiftUI

@available(iOS 16.0, *)
struct GiveFeedbackView: View{
    @ObservedObject var viewModel: GiveFeedbackViewModel
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
                
            HStack{
                Spacer()
                Image(ImageConstants.cross)
                    .onTapGesture {
                        viewModel.crossTapped()
                    }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16){
                    ReusableText(title: "give_feedback_heading", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                    
                    HStack{
                        ReusableText(title: "give_feedback_sub_heading", fontSize: 15, fontName: "Livvic-Medium", fontColor: AppColors.grey1)
                        
//                        Text("Company Name")
//                            .font(.custom("Livvic-SemiBold", size: 16))
//                            .foregroundColor(AppColors.textBlack1)
                    }
                    
                    ReusableText(title: "how_service_title", fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                        .padding(.top, 20)
                    
                    HStack{
                        Spacer()
                        RatingView(rating: viewModel.binding(for: \.state.userRating))
                        Spacer()
                    }
                    
                    // Any thoughts
                    VStack(alignment: .leading, spacing: 10) {
                        ReusableText(title: "overall_experience_title", fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                        
                        TextEditor(text: viewModel.binding(for: \.state.thoughts))
                            .font(.custom("Livvic-Regular", size: 14))
                            .frame(height: 120)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                            .overlay(alignment: .topLeading) {
                                if viewModel.state.thoughts.isEmpty {
                                    Text("Please share your thoughts...")
                                        .font(.custom("Livvic-Medium", size: 13))
                                        .foregroundColor(AppColors.grey1)
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 16)
                                        .allowsHitTesting(false)
                                }
                            }
                    }
                    .padding(.top, 15)
                }
                
            }
            .scrollIndicators(.hidden)
            
            Spacer()
            PrimaryButton(title: "submit_title", isEnabled: true)
            {
                
            }
            .padding(.bottom, 10)
            
        }
        .ignoresSafeArea(edges: .top)
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .navigationBarHidden(true)
        .dismissKeyboardOnTap()
        
    }
}

private struct RatingView: View{
    @Binding var rating: Int
    var body: some View{
        VStack(spacing: 16) {
            
            
            HStack{
                ForEach(0..<5, id: \.self){ index in
                    Image(index <= rating ? ImageConstants.startFilled : ImageConstants.startEmpty)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            withAnimation(.easeInOut){
                                rating = index
                            }
                        }
                }
            }
            HStack{
                ReusableText(title: "bad_title", fontSize: 12, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
                    .padding(.leading, 12)
                Spacer()
                ReusableText(title: "excellent_title", fontSize: 12, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
                
            }
        }
        .padding(.horizontal, 40)
    }
}
