//
//  BlurredArtworkBackground.swift
//  Looped
//

import SwiftUI

struct BlurredArtworkBackground: View {
    let artworkURL: URL?
    let fallbackColors: [Color]

    var body: some View {
        ZStack {
            if let url = artworkURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 60)
                            .scaleEffect(1.2)
                            .overlay(Color.black.opacity(0.4))
                    case .failure:
                        fallbackGradient
                    case .empty:
                        fallbackGradient
                    @unknown default:
                        fallbackGradient
                    }
                }
            } else {
                fallbackGradient
            }
        }
        .ignoresSafeArea()
    }

    private var fallbackGradient: some View {
        MeshGradientBackground(colors: fallbackColors)
    }
}

struct AnimatedBlurredBackground: View {
    let artworkURL: URL?
    let colors: [Color]
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            MeshGradientBackground(colors: colors)

            if let url = artworkURL {
                AsyncImage(url: url) { phase in
                    if case .success(let image) = phase {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 80)
                            .scaleEffect(isAnimating ? 1.3 : 1.2)
                            .opacity(0.6)
                            .animation(
                                .easeInOut(duration: 8).repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                }
            }

            // Vignette effect
            RadialGradient(
                colors: [.clear, .black.opacity(0.7)],
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
        }
        .ignoresSafeArea()
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    BlurredArtworkBackground(
        artworkURL: nil,
        fallbackColors: LoopedTheme.defaultGradient
    )
}
