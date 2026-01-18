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

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // App logo/icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)

                    Image(systemName: "infinity")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                }
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)

                // Year
                Text("\(year)")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
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

            // Swipe hint
            VStack(spacing: 8) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))

                Text("Swipe to continue")
                    .font(Typography.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .opacity(showSubtitle ? 1 : 0)
            .padding(.bottom, 60)
        }
        .storyCardStyle()
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.3)) {
                showYear = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.6)) {
                showSubtitle = true
            }
        }
    }
}

#Preview {
    ZStack {
        MeshGradientBackground(colors: LoopedTheme.welcomeGradient)
        WelcomeCard(year: 2025)
    }
}
