//
//  CheckboxField.swift
//  TruckMaster
//
//  Created by AuthentiCode on 04/06/26.
//

//
//  CheckboxField.swift
//  TruckMaster
//

internal import SwiftUI

struct CheckboxField: View {

    let label: String
    var isEditable: Bool = true
    @Binding var isChecked: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            // Checkbox
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isChecked ? AppColors.primary : Color.gray.opacity(0.4), lineWidth: 1.5)
                    .frame(width: 20, height: 20)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isChecked ? AppColors.primary : Color.white)
                    )

                if isChecked {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .onTapGesture {
                guard isEditable else { return }
                withAnimation(.easeInOut(duration: 0.15)) {
                    isChecked.toggle()
                }
            }

            // Label
            Text(LocalizedStringKey(label))
                .font(.custom("Livvic-Medium", size: 14))
                .foregroundColor(AppColors.textBlack1)
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture {
                    guard isEditable else { return }
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isChecked.toggle()
                    }
                }
        }
    }
}

// Basic
//CheckboxField(
//    label: "I agree to terms and conditions",
//    isChecked: $isAgreed
//)
//
//// Non-editable
//CheckboxField(
//    label: "Verified user",
//    isEditable: false,
//    isChecked: $isVerified
//)
//
//// With action
//CheckboxField(
//    label: "Remember me",
//    isChecked: $rememberMe
//)
//.onChange(of: rememberMe) { value in
//    print("Remember me: \(value)")
//}
