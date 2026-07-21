//
//  NameInputField.swift
//  TruckMaster
//
//  Created by AuthentiCode on 21/07/26.
//

internal import SwiftUI

struct NameInputField: View {

    let label: LocalizedStringKey
    let hint: String
    var icon: Image? = nil
    var isRequired: Bool = false
    var isEditable: Bool = true
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack(spacing: 2) {
                ReusableText(title: label, fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.textBlack1)

                if isRequired {
                    ReusableText(title: "", fontSize: 13, fontName: "Livvic-SemiBold", fontColor: AppColors.secondary)
                }
            }

            HStack(spacing: 12) {
                if let icon = icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                }

                NameGuardedTextField(
                    text: $text,
                    placeholder: NSLocalizedString(hint, comment: ""),
                    isEditable: isEditable
                )

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
