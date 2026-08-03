//
//  Extensions.swift
//  TruckMaster
//
//  Created by AuthentiCode on 03/06/26.
//

internal import SwiftUI

extension View {

    func cardStyle() -> some View {

        self
            .padding()
            .background(.white)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
    
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

extension ObservableObject where Self: AnyObject {
    func binding<T>(for keyPath: ReferenceWritableKeyPath<Self, T>) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

extension Data {

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}



extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DismissKeyboardOnTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}


extension String {
    var trimmedOrNil: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
    
    var lettersOnly: String {
           filter { $0.isLetter || $0 == " " }
       }
    
    var relativeTimeAgo: String {
           let formatter = ISO8601DateFormatter()
           formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

           guard let date = formatter.date(from: self) else { return "" }

           let seconds = max(0, Date().timeIntervalSince(date))
           let minutes = Int(seconds / 60)

           switch seconds {
           case ..<60:
               return "Just now"
           case ..<3600:
               return "\(minutes)min"
           case ..<86400:
               return "\(Int(seconds / 3600))h"
           default:
               return "\(Int(seconds / 86400))d"
           }
       }
}



// MARK: - Int

extension Int {
    var toString: String { String(self) }
    var toDouble: Double { Double(self) }
}

// MARK: - Double

extension Double {
    var toString: String { String(self) }
    var toInt: Int { Int(self) }
}

// MARK: - String

extension String {
    var toInt: Int { Int(self) ?? 0 }
    var toDouble: Double { Double(self) ?? 0.0 }
}

extension UITextField {
    func isLeadingSpace(range: NSRange, replacementString string: String) -> Bool {
        let currentText = self.text ?? ""
        return string == " " && currentText.isEmpty && range.location == 0
    }
}
