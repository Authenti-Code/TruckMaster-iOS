import SwiftUI
struct LabeledInputField: View {

    let label: LocalizedStringKey
    let hint: String
    var icon: Image? = nil
    var isRequired: Bool = false
    var isEditable: Bool = true
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    var lineLimit: ClosedRange<Int> = 1...1
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
            HStack(alignment: isMultiline ? .top : .center, spacing: 12) {

                if let icon = icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                }

                if isMultiline && lineLimit.upperBound > 1 {
                    if #available(iOS 16.0, *) {
                        TextField(LocalizedStringKey(hint), text: $text, axis: .vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(lineLimit)
                            .keyboardType(keyboardType)
                            .disabled(!isEditable)
                    } else {
                        // Fallback on earlier versions
                    }
                } else if isMultiline {
                    TextField(LocalizedStringKey(hint), text: $text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .keyboardType(keyboardType)
                        .disabled(!isEditable)
                } else {
                    SpaceGuardedTextField(
                        text: $text,
                        placeholder: hint,
                        isSecure: isSecure && !isPasswordVisible,
                        keyboardType: keyboardType,
                        isEditable: isEditable
                    )
                }

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
            .padding(.vertical, isMultiline ? 10 : 0)
            .frame(height: isMultiline ? nil : 48)
            .background(isEditable ? Color.white : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
