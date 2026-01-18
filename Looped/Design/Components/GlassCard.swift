//
//  GlassCard.swift
//  Looped
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(LoopedTheme.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: LoopedTheme.cardRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: LoopedTheme.cardRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.4),
                                        .white.opacity(0.1),
                                        .clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: LoopedTheme.cardShadow, radius: 20, y: 10)
    }
}

struct GlassCardDark<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(LoopedTheme.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: LoopedTheme.cardRadius)
                    .fill(Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: LoopedTheme.cardRadius)
                            .stroke(
                                Color.white.opacity(0.1),
                                lineWidth: 1
                            )
                    )
            )
    }
}

#Preview {
    ZStack {
        MeshGradientBackground(colors: LoopedTheme.defaultGradient)
        GlassCard {
            VStack {
                Text("Glass Card")
                    .font(Typography.cardTitle)
                    .foregroundStyle(.white)
                Text("With glassmorphism effect")
                    .font(Typography.body)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding()
    }
}
