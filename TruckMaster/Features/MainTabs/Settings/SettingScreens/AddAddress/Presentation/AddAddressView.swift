//
//  AddAddressView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

internal import SwiftUI
// AddAddressView.swift
@available(iOS 16.0, *)
struct AddAddressView: View {
    @ObservedObject var viewModel: AddAddressViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Nav Bar
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(
                    title: viewModel.isEditMode ? "edit_address_title" : "add_address_title",
                    fontSize: 18,
                    fontName: "Livvic-SemiBold",
                    fontColor: AppColors.textBlack1
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Address row
                    AddressPickerRow(
                        locationName: viewModel.state.selectedAddress.isEmpty
                            ? "Fetching address..."
                            : viewModel.state.selectedAddress,
                        subAddress: viewModel.state.selectedSubAddress,
                        onChangeTapped: {
                            viewModel.changeTapped()
                        }
                    )

                    // Name
                    NameInputField(
                        label: "name_required",
                        hint: "enter_receiver_name",
                        isRequired: true,
                        text: viewModel.nameBinding
                    )

                    // Contact
                    LabeledInputField(
                        label: "contact_required",
                        hint: "enter_contact",
                        isRequired: true,
                        keyboardType: .numberPad,
                        isMultiline: true,
                        lineLimit: 1...2,
                        text: viewModel.phoneBinding
                    )

                    // Save as
                    SaveAsSelector(selected: viewModel.binding(for: \.state.selectedLabel))
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)

            PrimaryButton(title: viewModel.isEditMode ? "update_title" : "add_title") {
                viewModel.addBtnTapped()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
        .overlay {
            if viewModel.state.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView().tint(.white).scaleEffect(1.5)
            }
        }
        .onAppear { viewModel.onAppear() }
        .dismissKeyboardOnTap()
    }
}

// AddressPickerRow.swift
struct AddressPickerRow: View {
    let locationName: String
    let subAddress: String
    let onChangeTapped: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(ImageConstants.location)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 3) {
                Text(locationName)
                    .font(.custom("Livvic-SemiBold", size: 15))
                    .foregroundColor(AppColors.textBlack1)
                    .lineLimit(1)

                if !subAddress.isEmpty {
                    Text(subAddress)
                        .font(.custom("Livvic-Regular", size: 13))
                        .foregroundColor(AppColors.grey1)
                        .lineLimit(1)
                }
            }

            Spacer()

            OutlineButton(title: "change_title", action: onChangeTapped)
        }
    }
}

// SaveAsSelector.swift
struct SaveAsSelector: View {
    @Binding var selected: AddressLabel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ReusableText(title: "save_as_title", fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)

            HStack(spacing: 0) {
                HStack(spacing: 10) {
                    ForEach(AddressLabel.allCases, id: \.self) { label in
                        LabelChip(label: label, isSelected: selected == label) {
                            selected = label
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

private struct LabelChip: View {
    let label: AddressLabel
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(isSelected ? label.selectedIcon : label.icon)
                    .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)

                Text(label.displayName)
                    .font(.custom("Livvic-Medium", size: 14))
            }
            .foregroundColor(isSelected ? AppColors.primary : AppColors.grey1)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isSelected
                        ? AppColors.colorBlue
                        : Color.clear
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? AppColors.primary : Color.gray.opacity(0.3),
                        lineWidth: 1.5
                    )
            )
        }
    }
}
