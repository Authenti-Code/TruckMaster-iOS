//
//  NameGuardedTextField.swift
//  TruckMaster
//
//  Created by AuthentiCode on 21/07/26.
//

internal import SwiftUI

struct NameGuardedTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    var isEditable: Bool = true
    var font: UIFont = UIFont(name: "Livvic-Medium", size: 15) ?? UIFont.systemFont(ofSize: 15)

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.delegate = context.coordinator
        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.placeholder = placeholder
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

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField.isLeadingSpace(range: range, replacementString: string) {
                return false
            }

            let currentText = textField.text ?? ""
            guard let swiftRange = Range(range, in: currentText) else { return true }

            let updatedText = currentText.replacingCharacters(in: swiftRange, with: string)

   
            if let firstChar = updatedText.first, firstChar.isNumber {
                return false
            }

        
            let isValidCharacter = string.isEmpty || string.allSatisfy { $0.isLetter || $0 == " " || $0 == "-" || $0 == "'" }
            guard isValidCharacter else { return false }

            text = updatedText
            return true
        }
    }
}
