//
//  ShimmerModifier.swift
//  TruckMaster
//
//  Created by AuthentiCode on 15/06/26.
//

internal import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.5),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 2)
                    .offset(x: phase * geo.size.width * 2)
                    .animation(
                        .linear(duration: 1.2).repeatForever(autoreverses: false),
                        value: phase
                    )
                }
                .clipped()
            )
            .onAppear { phase = 1 }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
