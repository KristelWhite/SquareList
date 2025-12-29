//
//  ShimmerModifier.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -0.7

    func body(content: Content) -> some View {
        content
            .overlay(gradientOverlay)
            .clipped()
            .onAppear { animate() }
    }

    private var gradientOverlay: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            LinearGradient(
                colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.35),
                    Color.white.opacity(0.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .rotationEffect(.degrees(18))
            .offset(x: phase * width)
            .blendMode(.luminosity)
        }
    }

    private func animate() {
        withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
            phase = 0.7
        }
    }
}

extension View {
    func shimmer() -> some View { modifier(ShimmerModifier()) }
}
