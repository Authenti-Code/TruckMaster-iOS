//
//  ShipmentCompletedView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//

internal import SwiftUI
@available(iOS 16.0, *)
struct ShipmentCompletedView: View {
    var viewModel: ShipmentCompletedViewModel
    var body: some View {
        ZStack {
            Image(ImageConstants.gradient1)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Image(ImageConstants.completed)
                    .padding(.bottom, 18)

                ReusableText(
                    title: "shipment_completed_title",
                    fontSize: 20,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
                .padding(.bottom, 18)

                ReusableText(
                    title: "shipment_completed_subheading",
                    fontSize: 15,
                    fontName: "Livvic-Medium",
                    fontColor: AppColors.grey1
                )
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 18)
                
                PrimaryButton(title: "share_your_experience_title") { }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 14)

                Button {
                    viewModel.backToHomeTapped()
                } label: {
                    ReusableText(
                        title: "back_to_home_title",
                        fontSize: 15,
                        fontName: "Livvic-SemiBold",
                        fontColor: AppColors.textBlack1
                    )
                }
                
                Spacer()

               
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .navigationBarHidden(true)
    }
}
