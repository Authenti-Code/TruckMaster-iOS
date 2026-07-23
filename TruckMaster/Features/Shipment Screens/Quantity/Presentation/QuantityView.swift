//
//  QuantityView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 22/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct QuantityView: View {
    @ObservedObject var viewModel: QuantityViewModel
   

    private var skeletonView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<10, id: \.self) { _ in
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
                
                
                Text(viewModel.state.categoryName.capitalized)
                    .font(.custom("Livvic-SemiBold", size: 18))
                    .foregroundColor(AppColors.textBlack1)
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            // SubCategory list
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
                        ForEach(viewModel.state.categories) { sub in
                            let count = viewModel.state.items.first(where: { $0.id == sub.id })?.count ?? 0

                            QuantityItemView(
                                item: sub,
                                count: count,
                                onMinus: { viewModel.minusTapped(subCategoryId: sub.id) },
                                onPlus: { viewModel.plusTapped(subCategoryId: sub.id) },
                                onSizesTapped: { viewModel.sizesTapped(subCategoryId: sub.id) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.hidden)
            }
      
            PrimaryButton(
                title: "next_text"
            ) {
                viewModel.nextTapped()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(isPresented: viewModel.binding(for: \.state.showSizesSheet)) {
          
                if let sizesViewModel = viewModel.makeSizesViewModel() {
                    if #available(iOS 16.4, *) {
                        SizesSheet(viewModel: sizesViewModel)
                            .presentationDetents([.height(350)])
                            .presentationDragIndicator(.visible)
                            .presentationBackground(.white)
                    } else {
                 
                    }
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

@available(iOS 16.0, *)
private struct QuantityItemView: View {
    let item: SubCategoryModel
    let count: Int
    let onMinus: () -> Void
    let onPlus: () -> Void
    let onSizesTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name.capitalized)
                    .font(.custom("Livvic-Medium", size: 15))
                    .foregroundColor(AppColors.textBlack1)

                if count > 0 {
                    Text("Add sizes >")
                        .font(.custom("Livvic-Medium", size: 14))
                        .foregroundColor(AppColors.colorRed2)
                        .onTapGesture {
                            onSizesTapped()
                        }
                }
            }

            Spacer()

            HStack(spacing: 16) {
                Button { onMinus() } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .semibold))
                               .padding(12)
                               .contentShape(Rectangle())
                }

                Text("\(count)")
                    .font(.custom("Livvic-SemiBold", size: 15))
                    .foregroundColor(AppColors.textBlack1)

                Button { onPlus() } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                               .padding(12)
                               .contentShape(Rectangle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
    }
}
