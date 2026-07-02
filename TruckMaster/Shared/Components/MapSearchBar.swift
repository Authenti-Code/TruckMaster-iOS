//
//  MapSearchBar.swift
//  TruckMaster
//

internal import SwiftUI

struct MapSearchBar: View {
    let placeholder: String
    let text: String
    let onTap: () -> Void

    init(
        placeholder: String = "search_location",
        text: String = "",
        onTap: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self.text = text
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                
                Text(text.isEmpty ? LocalizedStringKey(placeholder) : LocalizedStringKey(text))
                    .font(.custom("Livvic-Medium", size: 13))
                    .foregroundColor(text.isEmpty ? AppColors.grey1 : AppColors.textBlack1)
                    .lineLimit(1)
                Spacer()
                Image(ImageConstants.search)
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}
