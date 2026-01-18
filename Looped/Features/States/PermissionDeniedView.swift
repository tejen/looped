//
//  PermissionDeniedView.swift
//  Looped
//

import SwiftUI

struct PermissionDeniedView: View {
    var onRetry: (() -> Void)?
    @State private var isVisible = false

    var body: some View {
        ZStack {
            MeshGradientBackground(colors: [
                Color(red: 0.15, green: 0.15, blue: 0.2),
                Color(red: 0.2, green: 0.15, blue: 0.25),
                Color(red: 0.15, green: 0.2, blue: 0.25)
            ])
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 120, height: 120)

                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange)
                }
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)

                // Title & Message
                VStack(spacing: 16) {
                    Text("Apple Music Access Required")
                        .font(Typography.cardTitle)
                        .foregroundStyle(LoopedTheme.primaryText)
                        .multilineTextAlignment(.center)

                    Text("Looped needs access to your Apple Music library to create your personalized year in review.")
                        .font(Typography.body)
                        .foregroundStyle(LoopedTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)

                Spacer()

                // Actions
                VStack(spacing: 16) {
                    // Open Settings Button
                    Button(action: openSettings) {
                        HStack(spacing: 12) {
                            Image(systemName: "gear")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Open Settings")
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

                    // Try Again Button
                    Button(action: {
                        HapticManager.selection()
                        onRetry?()
                    }) {
                        Text("Try Again")
                            .font(Typography.body)
                            .foregroundStyle(LoopedTheme.secondaryText)
                            .padding(.vertical, 12)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
                .opacity(isVisible ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
        }
    }

    private func openSettings() {
        HapticManager.impact(.medium)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    PermissionDeniedView()
}
