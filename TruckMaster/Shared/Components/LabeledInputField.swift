//
//  LabeledInputField.swift
//  TruckMaster
//
//  Created by AuthentiCode on 04/06/26.
//

internal import SwiftUI

struct LabeledInputField: View {

    let label: LocalizedStringKey
    let hint: String
    var icon: Image? = nil
    var isRequired: Bool = false
    var isEditable: Bool = true
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    @Binding var text: String

    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Label
            HStack(spacing: 2) {
                ReusableText(title: label, fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)

                if isRequired {
                    ReusableText(title: "", fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.secondary)
                }
            }

            // Input Field
            HStack(spacing: 12) {

                if let icon = icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                }

                SpaceGuardedTextField(
                    text: $text,
                    placeholder: hint,
                    isSecure: isSecure && !isPasswordVisible,
                    keyboardType: keyboardType,
                    isEditable: isEditable
                )

                // Eye icon for password
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(isPasswordVisible ? ImageConstants.eyeSlash : ImageConstants.eye)
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }

                // Lock icon if not editable
                if !isEditable {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(isEditable ? Color.white : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
