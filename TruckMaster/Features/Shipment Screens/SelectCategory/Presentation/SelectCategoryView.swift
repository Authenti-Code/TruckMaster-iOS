//
//  NewCategoryView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SelectCategoryView: View {
    @ObservedObject var viewModel: SelectCategoryViewModel

    private var skeletonView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { _ in
                    SelectCategoryItemSkeliton()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(title: "select_category_title", fontSize: 18, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            HStack(spacing: 10) {
                VStack(spacing: 0) {
                    Image(ImageConstants.greenDot)
                        .padding(.top, 8)
                        .padding(.bottom, 8)

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
                                Text(viewModel.state.pickupName)
                                    .font(.custom("Livvic-SemiBold", size: 14))
                                    .foregroundColor(AppColors.textBlack1)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .layoutPriority(0)

                                if !viewModel.state.pickupPhone.isEmpty {
                                    Text("• \(viewModel.state.pickupPhone)")
                                        .font(.custom("Livvic-Regular", size: 13))
                                        .foregroundColor(AppColors.grey1)
                                        .lineLimit(1)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .layoutPriority(1)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) 
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

                    // Drop location
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 4) {
                                Text(viewModel.state.dropName)
                                    .font(.custom("Livvic-SemiBold", size: 14))
                                    .foregroundColor(AppColors.textBlack1)
                                if !viewModel.state.dropPhone.isEmpty {
                                    Text("• \(viewModel.state.dropPhone)")
                                        .font(.custom("Livvic-Regular", size: 13))
                                        .foregroundColor(AppColors.grey1)
                                }
                            }
                            Text(viewModel.state.dropAddress)
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
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .padding(.horizontal, 20)

            // Category list
            if viewModel.state.isLoading {
                skeletonView
            } else if viewModel.state.categories.isEmpty {
                Spacer()
                EmptyStateView(
                    image: ImageConstants.noSavedAddress,
                    title: "no_category_found_heading",
                    message: "no_category_found_subheading"
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.state.categories) { category in
                            SelectCategoryItemView(
                                item: category,
                                selectedItems: viewModel.selectedItems(for: category.id)
                            )
                            .onTapGesture {
                                if category.hasSubcategories{
                                    viewModel.categoryTapped(category)
                                }
                                else
                                {
                                    print("No sub category..")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                }
                .scrollIndicators(.hidden)
            }
      
            PrimaryButton(
                title: "proceed_title",
                isEnabled: viewModel.draft.items.isEmpty ? false : true
            ) {
                viewModel.proceedTapped()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
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
    }
}
@available(iOS 16.0, *)
private struct SelectCategoryItemView: View {
    let item: CategoryModel
    let selectedItems: [ItemRequest]

    private func subCategoryName(for id: Int?) -> String {
        guard let id, let match = item.subCategories.first(where: { $0.id == id }) else {
            return ""
        }
        return match.name.capitalized
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {

                AsyncImage(url: URL(string: item.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
//                        Color(AppColors.grey3)
                    }
                }
                .frame(width: 55, height: 55)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name.capitalized)
                        .font(.custom("Livvic-Medium", size: 15))
                        .foregroundColor(AppColors.textBlack1)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            if !selectedItems.isEmpty {
                Divider()
                    .padding(.horizontal, 15)

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        ForEach(Array(selectedItems.enumerated()), id: \.offset) { index, selected in
                            Text("\(selected.quantity ?? 0) \(subCategoryName(for: selected.subCategoryId))")

                                .font(.custom("Livvic-Medium", size: 13))
                                .foregroundColor(AppColors.textBlack1)

                            if index < selectedItems.count - 1 {
                                Circle()
                                    .fill(AppColors.grey1)
                                    .frame(width: 4, height: 4)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .scrollIndicators(.hidden)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}
 struct SelectCategoryItemSkeliton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Circle()
                .fill(AppColors.grey3)
                .frame(width: 32, height: 32)
                .shimmer()

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.grey3)
                    .frame(width: 100, height: 13)
                    .shimmer()

                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.grey3)
                    .frame(width: 180, height: 11)
                    .shimmer()
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)
        )
    }
}


