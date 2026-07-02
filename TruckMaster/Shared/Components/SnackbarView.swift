//
//  SnackbarView.swift
//  TruckMaster
//
//  Created by AuthentiCode on 05/06/26.
//

internal import SwiftUI

enum SnackbarType {
    case error
    case success
    case info

    var color: Color {
        switch self {
        case .error:   return Color.red.opacity(0.9)
        case .success: return Color.green.opacity(0.9)
        case .info:    return Color.gray.opacity(0.9)
        }
    }

    var icon: String {
        switch self {
        case .error:   return "xmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .info:    return "info.circle.fill"
        }
    }
}

struct SnackbarView: View {

    let message: String
    var type: SnackbarType = .error

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .foregroundColor(.white)
                .font(.system(size: 18))

            Text(message)
                .font(.custom("Livvic-Medium", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(type.color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}
