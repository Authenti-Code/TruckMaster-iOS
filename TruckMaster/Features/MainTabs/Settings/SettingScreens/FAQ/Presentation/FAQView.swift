//
//  FAQView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 18/06/26.
//


internal import SwiftUI

@available(iOS 16.0, *)
struct FAQView: View {
    @ObservedObject var viewModel: FAQViewModel

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
                    title: "faq_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ReusableText(
                        title: "faq_subheading",
                        fontSize: 14,
                        fontName: "Livvic-Medium",
                        fontColor: AppColors.grey1
                    )
                    LazyVStack(spacing: 12) {
                                ForEach(viewModel.state.faqs) { faq in
                                    FAQRow(item: faq) {
                                        viewModel.toggleFAQ(id: faq.id)
                                    }
                                }
                            }
                }
                
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
//        .overlay {
//            if viewModel.state.isLoading {
//                Color.black.opacity(0.3).ignoresSafeArea()
//                ProgressView().tint(.white).scaleEffect(1.5)
//            }
//        }
    }
}
struct FAQRow: View {

    let item: FAQItem
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Button(action: onTap) {
                HStack(alignment: .top) {

                    Text(item.question)
                        .font(.custom("Livvic-SemiBold", size: 14))
                        .foregroundColor(AppColors.textBlack1)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)

            if item.isExpanded {
                Text(item.answer)
                    .font(.custom("Livvic-Medium", size: 13))
                    .foregroundColor(AppColors.grey1)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 14)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity
                        )
                    )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(item.isExpanded ? AppColors.grey3 : .clear)
        )
        .animation(.easeOut(duration: 0.15), value: item.isExpanded)
    }
}
