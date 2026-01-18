//
//  OnboardingView.swift
//  Looped
//

import SwiftUI
import MusicKit

struct OnboardingView: View {
    @Binding var isAuthorized: Bool
    var onPermissionDenied: (() -> Void)?
    @State private var isAnimating = false
    @State private var isRequesting = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            // Background
            MeshGradientBackground(colors: LoopedTheme.welcomeGradient)

            VStack(spacing: 0) {
                Spacer()

                // Logo and title
                VStack(spacing: 32) {
                    // Animated logo
                    ZStack {
                        // Glow circles
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.1 - Double(index) * 0.03),
                                    lineWidth: 2
                                )
                                .frame(width: CGFloat(140 + index * 30), height: CGFloat(140 + index * 30))
                                .scaleEffect(isAnimating ? 1.1 : 1)
                                .animation(
                                    .easeInOut(duration: 2)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                    value: isAnimating
                                )
                        }

                        // Main icon
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "infinity")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                    }

                    VStack(spacing: 12) {
                        Text("Looped")
                            .font(Typography.heroTitle)
                            .foregroundStyle(LoopedTheme.primaryText)

                        Text("Your Year in Music")
                            .font(Typography.cardSubtitle)
                            .foregroundStyle(LoopedTheme.secondaryText)
                    }
                }

                Spacer()

                // Description
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        FeatureRow(
                            icon: "music.note.list",
                            title: "Your Top Songs",
                            description: "See the tracks you couldn't stop playing"
                        )

                        FeatureRow(
                            icon: "person.2.fill",
                            title: "Favorite Artists",
                            description: "Discover who dominated your playlists"
                        )

                        FeatureRow(
                            icon: "sparkles",
                            title: "Audio Aura",
                            description: "Uncover your unique listening personality"
                        )
                    }
                    .padding(.horizontal, 32)

                    // Permission note
                    Text("We'll need access to your Apple Music library to create your personalized experience.")
                        .font(Typography.caption)
                        .foregroundStyle(LoopedTheme.tertiaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                // CTA Button
                Button(action: requestAccess) {
                    HStack(spacing: 12) {
                        if isRequesting {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Image(systemName: "music.note")
                            Text("Connect Apple Music")
                        }
                    }
                    .font(Typography.buttonLarge)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(Color.white)
                    )
                }
                .disabled(isRequesting)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }

            // Error overlay
            if showError {
                ErrorOverlay(message: errorMessage) {
                    showError = false
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }

    private func requestAccess() {
        isRequesting = true
        HapticManager.impact(.medium)

        Task {
            do {
                let authorized = try await MusicKitService.shared.requestAuthorization()
                await MainActor.run {
                    isRequesting = false
                    if authorized {
                        HapticManager.notification(.success)
                        withAnimation {
                            isAuthorized = true
                        }
                    }
                }
            } catch MusicKitService.AuthorizationError.denied {
                await MainActor.run {
                    isRequesting = false
                    HapticManager.notification(.error)
                    onPermissionDenied?()
                }
            } catch MusicKitService.AuthorizationError.restricted {
                await MainActor.run {
                    isRequesting = false
                    HapticManager.notification(.error)
                    onPermissionDenied?()
                }
            } catch {
                await MainActor.run {
                    isRequesting = false
                    errorMessage = "Something went wrong. Please try again."
                    showError = true
                    HapticManager.notification(.error)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(LoopedTheme.primaryText)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.1))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Typography.bodyBold)
                    .foregroundStyle(LoopedTheme.primaryText)

                Text(description)
                    .font(Typography.caption)
                    .foregroundStyle(LoopedTheme.secondaryText)
            }

            Spacer()
        }
    }
}

struct ErrorOverlay: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.orange)

                Text(message)
                    .font(Typography.body)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .multilineTextAlignment(.center)

                Button(action: onDismiss) {
                    Text("OK")
                        .font(Typography.buttonLarge)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                        )
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
            )
            .padding(40)
        }
    }
}

#Preview {
    OnboardingView(isAuthorized: .constant(false))
}
