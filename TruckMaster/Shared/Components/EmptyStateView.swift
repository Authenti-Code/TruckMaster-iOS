//
//  EmptyStateView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 11/06/26.
//


internal import SwiftUI

struct EmptyStateView: View {

    let image: String?
    let title: String?
    let message: String?
    let buttonTitle: String?
    let buttonAction: (() -> Void)?

    init(
        image: String? = nil,
        title: String? = nil,
        message: String? = nil,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.image        = image
        self.title        = title
        self.message      = message
        self.buttonTitle  = buttonTitle
        self.buttonAction = buttonAction
    }

    var body: some View {
        VStack(spacing: 10) {

            if let image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 120)
            }

            if let title {
                ReusableText(
                    title: LocalizedStringKey(title),
                    fontSize: 16,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
                .multilineTextAlignment(.center)
            }

            if let message {
                ReusableText(
                    title: LocalizedStringKey(message),
                    fontSize: 14,
                    fontName: "Livvic-Medium",
                    fontColor: AppColors.grey1
                )
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            }

            if let buttonTitle, let buttonAction {
                Button(action: buttonAction) {
                    ReusableText(
                        title: LocalizedStringKey(buttonTitle),
                        fontSize: 14,
                        fontName: "Livvic-SemiBold",
                        fontColor: .white
                    )
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(AppColors.primary)
                    .cornerRadius(24)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    VStack(spacing: 40) {

        // image + title + message + button
        EmptyStateView(
            image: "ic_no_orders",
            title: "No Shipments",
            message: "You have no current shipments at the moment.",
            buttonTitle: "Start New Shipment"
        ) {
            print("button tapped")
        }

        // title + message only
        EmptyStateView(
            title: "No Orders",
            message: "Your orders will appear here."
        )

        // image + title only
        EmptyStateView(
            image: "ic_empty",
            title: "Nothing here"
        )
    }
}
