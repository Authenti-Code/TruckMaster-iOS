//
//  SpaceGuardedTextField.swift
//  TruckMaster
//

internal import SwiftUI

struct SpaceGuardedTextField: UIViewRepresentable {

    @Binding var text: String

    var placeholder: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var isEditable: Bool = true
    var font: UIFont = UIFont(name: "Livvic-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)
    var returnKeyType: UIReturnKeyType = .default

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.returnKeyType = returnKeyType
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {

        if uiView.text != text && !uiView.isFirstResponder {
            uiView.text = text
        }

        uiView.placeholder = LanguageManager.shared.localizedString(for: placeholder)

        if uiView.isSecureTextEntry != isSecure {
            uiView.isSecureTextEntry = isSecure
        }

        if uiView.keyboardType != keyboardType {
            uiView.keyboardType = keyboardType
        }

        let desiredContentType: UITextContentType? = isSecure ? .password : nil
        if uiView.textContentType != desiredContentType {
            uiView.textContentType = desiredContentType
        }

        uiView.isEnabled = isEditable
        uiView.font = font
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            self._text = text
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {

            if string == "\n" {
                return false
            }

            if textField.isLeadingSpace(range: range, replacementString: string) {
                return false
            }

            let currentText = textField.text ?? ""

            if let swiftRange = Range(range, in: currentText) {
                text = currentText.replacingCharacters(in: swiftRange, with: string)
            }

            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return false
        }
    }
}
