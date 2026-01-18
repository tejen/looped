//
//  EmptyLibraryView.swift
//  Looped
//

import SwiftUI

struct EmptyLibraryView: View {
    var onRetry: (() -> Void)?
    @State private var isVisible = false

    var body: some View {
        ZStack {
            MeshGradientBackground(colors: [
                Color(red: 0.1, green: 0.15, blue: 0.2),
                Color(red: 0.15, green: 0.1, blue: 0.2),
                Color(red: 0.1, green: 0.2, blue: 0.2)
            ])
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 120, height: 120)

                    Image(systemName: "music.note.house.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.blue)
                }
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)

                // Title & Message
                VStack(spacing: 16) {
                    Text("Your Library is Empty")
                        .font(Typography.cardTitle)
                        .foregroundStyle(LoopedTheme.primaryText)
                        .multilineTextAlignment(.center)

                    Text("Start listening to music on Apple Music to build your library. Once you have some listening history, come back to see your personalized Wrapped!")
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
                    // Open Apple Music Button
                    Button(action: openAppleMusic) {
                        HStack(spacing: 12) {
                            Image(systemName: "music.note")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Open Apple Music")
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

                    // Retry Button
                    Button(action: {
                        HapticManager.selection()
                        onRetry?()
                    }) {
                        Text("Check Again")
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

    private func openAppleMusic() {
        HapticManager.impact(.medium)
        if let url = URL(string: "music://") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    EmptyLibraryView()
}
