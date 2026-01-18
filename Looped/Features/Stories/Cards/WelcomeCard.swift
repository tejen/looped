//
//  WelcomeCard.swift
//  Looped
//

import SwiftUI

struct WelcomeCard: View {
    let year: Int
    @State private var isVisible = false
    @State private var showYear = false
    @State private var showSubtitle = false
    @State private var pulseRings = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // App logo/icon with pulsing rings
                ZStack {
                    // Animated pulse rings
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(Color.white.opacity(0.15 - Double(index) * 0.04), lineWidth: 2)
                            .frame(width: CGFloat(120 + index * 40), height: CGFloat(120 + index * 40))
                            .scaleEffect(pulseRings ? 1.2 : 1.0)
                            .opacity(pulseRings ? 0 : 0.6)
                            .animation(
                                .easeOut(duration: 2)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.4),
                                value: pulseRings
                            )
                    }

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.25), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        )

                    Image(systemName: "infinity")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.5), radius: 10)
                }
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)

                // Year with gradient
                Text(year, format: .number.grouping(.never))
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                    .opacity(showYear ? 1 : 0)
                    .scaleEffect(showYear ? 1 : 0.8)
                    .offset(y: showYear ? 0 : 30)

                // Title
                VStack(spacing: 8) {
                    Text("Your Year in Music")
                        .font(Typography.cardTitle)
                        .foregroundStyle(.white)

                    Text("Tap to explore your listening journey")
                        .font(Typography.body)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .opacity(showSubtitle ? 1 : 0)
                .offset(y: showSubtitle ? 0 : 20)
            }

            Spacer()

            // Swipe hint with animated chevron
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.3 + Double(index) * 0.15))
                    }
                }

                Text("Swipe to continue")
                    .font(Typography.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .opacity(showSubtitle ? 1 : 0)
            .padding(.bottom, 60)
        }
        .storyCardStyle()
        .onAppear {
            pulseRings = true
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.3)) {
                showYear = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.6)) {
                showSubtitle = true
            }
            HapticManager.notification(.success)
        }
    }
}

#Preview {
    ZStack {
        MeshGradientBackground(colors: LoopedTheme.welcomeGradient)
        WelcomeCard(year: 2025)
    }
}
