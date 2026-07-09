//
//  SizesSheet.swift
//  TruckMaster
//
//  Created by AuthentiCode on 23/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct SizesSheet: View {

    @ObservedObject var viewModel: SizesViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        //menu popup
        VStack(alignment: .leading) {
            HStack {
                ReusableText(title: "dimensions_title", fontSize: 16, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
                Spacer()
                Menu {
                    ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                        Button(unit.rawValue) {
                            viewModel.unitChanged(to: unit)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.state.selectedUnit.rawValue)
                            .font(.custom("Livvic-Medium", size: 13))
                            .foregroundColor(AppColors.textBlack1)

                        Image(ImageConstants.downArrow)
                  
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.grey3)
                    )
                }
            }
            
            //sizes options
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.state.dimensions.indices, id: \.self) { index in
                            SizeItem(
                                itemName: viewModel.state.subCategoryName.capitalized,
                                width: Binding(
                                    get: { viewModel.displayValue(forCm: viewModel.state.dimensions[index].widthInCm) },
                                    set: { viewModel.updateWidth(at: index, fromInput: $0) }
                                ),
                                length: Binding(
                                    get: { viewModel.displayValue(forCm: viewModel.state.dimensions[index].lengthInCm) },
                                    set: { viewModel.updateLength(at: index, fromInput: $0) }
                                )
                            )
                    }
                }
            }
            .scrollIndicators(.hidden)

            //checkbox
            if viewModel.state.itemCount > 1 {
                Button {
                    viewModel.sameDimensionsToggled(!viewModel.state.applySameDimensions)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.state.applySameDimensions ? "checkmark.square.fill" : "square")
                            .foregroundColor(viewModel.state.applySameDimensions ? AppColors.primary : AppColors.grey1)

                        Text("All are of same size.")
                            .font(.custom("Rubik-Regular", size: 15))
                            .foregroundColor(AppColors.textBlack1)
                    }
                }
                .padding(.bottom, 12)
            }
           

            //save button
            PrimaryButton(title: "save_title") {
                if viewModel.saveTapped() {
                    dismiss()
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .dismissKeyboardOnTap()
    }
}

private struct SizeItem: View {
    let itemName: String
    @Binding var width: String
    @Binding var length: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {

            Text(itemName)
                .font(.custom("Livvic-Medium", size: 15))
                .foregroundColor(AppColors.textBlack1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)

            HStack(alignment: .center, spacing: 8) {

                LabeledInputField(
                    label: "",
                    hint: "Width",
                    isRequired: true,
                    keyboardType: .decimalPad,
                    text: $width,
                )
                .frame(width: 100)

                Text("X")
                    .font(.custom("Livvic-Medium", size: 13))
                    .foregroundColor(AppColors.grey1)
                    .padding(.top, 12)
                    .frame(width: 16)
                    .layoutPriority(1)

                LabeledInputField(
                    label: "",
                    hint: "Length",
                    isRequired: true,
                    keyboardType: .decimalPad,
                    text: $length
                )
                .frame(width: 100)
                .padding(.trailing, 5)
            }
        }
        .frame(minHeight: 44)
    }
}
