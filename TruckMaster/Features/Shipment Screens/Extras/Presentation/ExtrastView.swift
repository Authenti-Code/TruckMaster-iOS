//
//  ExtrastView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 24/06/26.
//

internal import SwiftUI

@available(iOS 16.0, *)
struct ExtrasView: View {
    @ObservedObject var viewModel: ExtrasViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                HStack {
                    Button { viewModel.backTapped() } label: {
                        Image(ImageConstants.backImage)
                    }
                    Spacer()
                }
                ReusableText(title: "extras_title", fontSize: 18, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            ScrollView {
                VStack(spacing: 16) {

                    // Helper counter
                    HelperCounterRow(
                        count: viewModel.state.helpers,
                        onMinus: { viewModel.helperMinusTapped() },
                        onPlus: { viewModel.helperPlusTapped() }
                    )

                    // Multi-select toggles
                    
                    ExtraToggleRow(title: "fragile_handling_title", isSelected: viewModel.state.fragileHandling) {
                        viewModel.fragileHandlingTapped()
                    }

                    ExtraToggleRow(title: "stairs_carry_title", isSelected: viewModel.state.stairsCarry) {
                        viewModel.stairsCarryTapped()
                    }

                    ExtraToggleRow(title: "urgent_title", isSelected: viewModel.state.urgent) {
                        viewModel.urgentTapped()
                    }

                    ExtraToggleRow(title: "zip_handler_title", isSelected: viewModel.state.zipHandler) {
                        viewModel.zipHandlerTapped()
                    }

                    // Elevator Yes/No
                    ElevatorRow(
                        isYes: viewModel.state.elevator,
                        onChange: { viewModel.elevatorChanged(to: $0) }
                    )

                    // Additional info
                    VStack(alignment: .leading, spacing: 8) {
                        
                        ReusableText(title: "addition_info_title", fontSize: 14, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)

                        TextEditor(text: viewModel.binding(for: \.state.additionalInfo))
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
                                if viewModel.state.additionalInfo.isEmpty {
                                    ReusableText(title: "type_here_text", fontSize: 14, fontName: "Livvic-Regular", fontColor: AppColors.grey1)
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 16)
                                        .allowsHitTesting(false)
                                }
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)

            PrimaryButton(title: "next_text") {
                viewModel.nextTapped()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarHidden(true)
        .dismissKeyboardOnTap()
        .snackbar(
            isShowing: viewModel.binding(for: \.state.showSnackbar),
            message: viewModel.state.snackbarMessage,
            type: viewModel.state.snackbarType
        )
    }
}

@available(iOS 16.0, *)
private struct HelperCounterRow: View {
    let count: Int
    let onMinus: () -> Void
    let onPlus: () -> Void

    var body: some View {
        HStack {
            
            ReusableText(title: "helper_text", fontSize: 15, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)
            
            Spacer()

            HStack(spacing: 16) {
                Button { onMinus() } label: {
                    Image(systemName: "minus")
                }

                Text("\(count)")
                    .font(.custom("Livvic-SemiBold", size: 15))
                    .foregroundColor(AppColors.textBlack1)

                Button { onPlus() } label: {
                    Image(systemName: "plus")
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

@available(iOS 16.0, *)
private struct ExtraToggleRow: View {
    let title: LocalizedStringKey
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            HStack {
       
                ReusableText(title: title, fontSize: 15, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isSelected ? AppColors.colorBlue : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppColors.primary : Color.gray.opacity(0.15), lineWidth: isSelected ? 1.5 : 1)
            )
        }
    }
}

@available(iOS 16.0, *)
private struct ElevatorRow: View {
    let isYes: Bool
    let onChange: (Bool) -> Void

    var body: some View {
        HStack {
            ReusableText(title: "elevator_title", fontSize: 15, fontName: "Livvic-Medium", fontColor: AppColors.textBlack1)

            Spacer()

            RadioOption(label: "yes_title", isSelected: isYes) { onChange(true) }
            RadioOption(label: "no_title", isSelected: !isYes) { onChange(false) }
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

private struct RadioOption: View {
    let label: LocalizedStringKey
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button { onTap() } label: {
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? AppColors.primary : Color.gray.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 18, height: 18)

                    if isSelected {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 10, height: 10)
                    }
                }
                
                ReusableText(title: label, fontSize: 14, fontName: "Livvic-Regular", fontColor: AppColors.textBlack1)
                
            }
            .padding(.trailing, 12)
        }
    }
}
