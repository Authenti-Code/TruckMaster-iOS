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
                    text: $digits[index],
                    isFocused: focusedIndex == index,
                    onBackspaceOnEmpty: { handleBackspaceOnEmpty(at: index) }
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

        // update otp binding
        otp = digits.joined()
    }

    private func handleBackspaceOnEmpty(at index: Int) {
        guard index > 0 else { return }

        focusedIndex = index - 1
    }
}

// MARK: - OTP Box
struct OTPBox: View {

    @Binding var text: String
    var isFocused: Bool
    var onBackspaceOnEmpty: () -> Void

    var body: some View {
        BackspaceDetectingTextField(
            text: $text,
            onBackspaceOnEmpty: onBackspaceOnEmpty
        )
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

// MARK: - Backspace-aware text field
struct BackspaceDetectingTextField: UIViewRepresentable {

    @Binding var text: String
    var onBackspaceOnEmpty: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = BackspaceCapturingUITextField()
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.onDeleteBackwardWhenEmpty = onBackspaceOnEmpty
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        (uiView as? BackspaceCapturingUITextField)?.onDeleteBackwardWhenEmpty = onBackspaceOnEmpty
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>

        init(text: Binding<String>) {
            self.text = text
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let current = textField.text ?? ""
            guard let stringRange = Range(range, in: current) else { return true }
            let updated = current.replacingCharacters(in: stringRange, with: string)
            text.wrappedValue = updated
            return false
        }
    }
}

private final class BackspaceCapturingUITextField: UITextField {
    var onDeleteBackwardWhenEmpty: (() -> Void)?

    override func deleteBackward() {
        if (text ?? "").isEmpty {
            onDeleteBackwardWhenEmpty?()
            return
        }
        super.deleteBackward()
    }
}
