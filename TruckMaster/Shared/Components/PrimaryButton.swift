//
//  PrimaryButton.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI

struct PrimaryButton: View {

    let title: LocalizedStringKey
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Livvic-SemiBold", size: 16))
                .foregroundColor(
                                  isEnabled
                                  ? .white
                                  : AppColors.grey5
                              )
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isEnabled
                    ? AppColors.primary
                    : AppColors.grey3
                )
               
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .disabled(!isEnabled)
    }
}

struct PrimaryDanger: View {

    let title: LocalizedStringKey
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Livvic-SemiBold", size: 16))
                .foregroundColor(
                                  isEnabled
                                  ? .white
                                  : AppColors.grey5
                              )
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    isEnabled
                    ? AppColors.colorRed2
                    : AppColors.grey3
                )
               
                .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .disabled(!isEnabled)
    }
}

struct ReusableText: View {
    let title: LocalizedStringKey
    let fontSize: CGFloat
    let fontName: String
    let fontColor: Color

    var body: some View {
        Text(title)
            .font(.custom(fontName, size: fontSize))
            .foregroundColor(fontColor)
    }
}

struct DropdownField: View {

    let hint: LocalizedStringKey
    let options: [String]
    var icon: Image? = nil
    var isEditable: Bool = true
    @Binding var selected: String
    @State private var showDropdown = false

    var body: some View {
        VStack(spacing: 6) {

            // Field
            HStack(spacing: 12) {

                if let icon = icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                }

                if selected.isEmpty {
                    Text(hint)
                        .font(.custom("Livvic-Medium", size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(selected)
                        .font(.custom("Livvic-Medium", size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if isEditable {
                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium))
                        .animation(.easeInOut, value: showDropdown)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Color.white)
            .clipShape(
                showDropdown
                ? RoundedRectangle(cornerRadius: 10).inset(by: 0)
                : RoundedRectangle(cornerRadius: 10).inset(by: 0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                guard isEditable else { return }
//                withAnimation(.easeInOut(duration: 0.2)) {
                    showDropdown.toggle()
//                }
            }

            // Dropdown List
            if showDropdown {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        HStack {
                            Text(option)
                                .font(.custom("Livvic-Medium", size: 16))
                                .foregroundColor(.black)

                            Spacer()

                            if selected == option {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.primary)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(selected == option ? AppColors.primary.opacity(0.05) : Color.white)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selected = option
                            showDropdown = false
                        }

                        if option != options.last {
                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
