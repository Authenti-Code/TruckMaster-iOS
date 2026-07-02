//
//  OTPInputField.swift
//  TruckMaster
//
//  Created by AuthentiCode on 08/06/26.
//

internal import SwiftUI

struct OTPInputField: View {

    let numberOfFields: Int
    @Binding var otp: String
    @FocusState private var focusedIndex: Int?

    @State private var digits: [String]

    init(numberOfFields: Int = 4, otp: Binding<String>) {
        self.numberOfFields = numberOfFields
        self._otp           = otp
        self._digits        = State(initialValue: Array(repeating: "", count: numberOfFields))
    }

    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                OTPBox(
                    text:      $digits[index],
                    isFocused: focusedIndex == index
                )
                .focused($focusedIndex, equals: index)
                .onChange(of: digits[index]) { newValue in
                    handleInput(newValue, at: index)
                }
            }
        }
    }

    private func handleInput(_ value: String, at index: Int) {
        // allow only one digit
        if value.count > 1 {
            digits[index] = String(value.last ?? Character(""))
        }

        // move forward
        if !digits[index].isEmpty && index < numberOfFields - 1 {
            focusedIndex = index + 1
        }

        // move backward on delete
        if digits[index].isEmpty && index > 0 {
            focusedIndex = index - 1
        }

        // update otp binding
        otp = digits.joined()
    }
}

// MARK: - OTP Box
struct OTPBox: View {

    @Binding var text: String
    var isFocused: Bool

    var body: some View {
        TextField("-", text: $text)
            .font(.custom("Magra-Bold", size: 22))
            .foregroundColor(AppColors.textBlack1)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(width: 60, height: 60)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? AppColors.primary : Color.gray.opacity(0.3),
                        lineWidth: isFocused ? 2 : 1
                    )
            )
    }
}
