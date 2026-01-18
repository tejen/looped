//
//  View+Extensions.swift
//  Looped
//

import SwiftUI

extension View {
    func fadeSlide(isVisible: Bool, delay: Double = 0) -> some View {
        self
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 30)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: isVisible)
    }

    func scaleOnAppear(delay: Double = 0) -> some View {
        modifier(ScaleOnAppearModifier(delay: delay))
    }

    func glowEffect(color: Color, radius: CGFloat = 20) -> some View {
        self.shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
    }

    func storyCardStyle() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 80)
    }
}

struct ScaleOnAppearModifier: ViewModifier {
    let delay: Double
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay)) {
                    scale = 1
                    opacity = 1
                }
            }
    }
}

extension AnyTransition {
    static var storySlide: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }

    static var storyFade: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.95))
    }
}
