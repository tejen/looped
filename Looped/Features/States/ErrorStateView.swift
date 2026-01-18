//
//  ErrorStateView.swift
//  Looped
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    var onRetry: (() -> Void)?
    @State private var isVisible = false

    var body: some View {
        ZStack {
            MeshGradientBackground(colors: [
                Color(red: 0.2, green: 0.1, blue: 0.15),
                Color(red: 0.25, green: 0.1, blue: 0.1),
                Color(red: 0.2, green: 0.15, blue: 0.15)
            ])
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 120, height: 120)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.red)
                }
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)

                // Title & Message
                VStack(spacing: 16) {
                    Text("Something Went Wrong")
                        .font(Typography.cardTitle)
                        .foregroundStyle(LoopedTheme.primaryText)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(Typography.body)
                        .foregroundStyle(LoopedTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)

                Spacer()

                // Retry Button
                VStack(spacing: 16) {
                    Button(action: {
                        HapticManager.impact(.medium)
                        onRetry?()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Try Again")
                                .font(Typography.buttonLarge)
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
                .opacity(isVisible ? 1 : 0)
            }
        }
        .onAppear {
            HapticManager.error()
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ErrorStateView(message: "We couldn't load your music data. Please check your internet connection and try again.")
}
