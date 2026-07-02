//
//  OutlineButton.swift
//  TruckMaster
//
//  Created by AuthentiCode on 16/06/26.
//

internal import SwiftUI

struct OutlineButton: View {
    let title: LocalizedStringKey
    var color: Color = AppColors.textBlack1
    var backgroundColor: Color = AppColors.colorBlue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Livvic-SemiBold", size: 11))
                .foregroundColor(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(backgroundColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 1.5)
                )
        }
    }
}

// Basic
//OutlineButton(title: "Continue") {
//    viewModel.onContinueTapped()
//}

// Custom color
//OutlineButton(title: "Cancel", color: .red) {
//    dismiss()
//}
