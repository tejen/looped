//
//  SummaryCard.swift
//  Looped
//

import SwiftUI

struct SummaryCard: View {
    let stats: ListeningStats
    var onReplay: (() -> Void)?
    @State private var isVisible = false
    @State private var showStats = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 32) {
                    // Header with celebration emoji
                    VStack(spacing: 12) {
                        Text("Your \(stats.year)")
                            .font(Typography.cardSubtitle)
                            .foregroundStyle(LoopedTheme.secondaryText)

                        Text("Wrapped")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        Text("What a year for music!")
                            .font(Typography.body)
                            .foregroundStyle(LoopedTheme.secondaryText)
                    }
                    .opacity(isVisible ? 1 : 0)

                    // Summary grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        SummaryStatBox(
                            icon: "clock.fill",
                            value: "\(stats.totalHours)",
                            label: "hours",
                            color: .blue,
                            delay: 0.1,
                            show: showStats
                        )

                        SummaryStatBox(
                            icon: "music.note.list",
                            value: "\(stats.totalSongsPlayed.formatted())",
                            label: "songs",
                            color: .purple,
                            delay: 0.2,
                            show: showStats
                        )

                        SummaryStatBox(
                            icon: "person.2.fill",
                            value: "\(stats.totalArtistsDiscovered)",
                            label: "artists",
                            color: .pink,
                            delay: 0.3,
                            show: showStats
                        )

                        SummaryStatBox(
                            icon: "star.fill",
                            value: stats.topArtists.first?.name ?? "-",
                            label: "#1 artist",
                            color: .orange,
                            delay: 0.4,
                            show: showStats,
                            isText: true
                        )
                    }
                    .padding(.horizontal, 8)

                    // Share button
                    ShareButton(stats: stats)
                        .opacity(showStats ? 1 : 0)
                        .offset(y: showStats ? 0 : 20)

                    // Replay button
                    Button(action: {
                        HapticManager.selection()
                        onReplay?()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Watch again")
                        }
                        .font(Typography.body)
                        .foregroundStyle(LoopedTheme.secondaryText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                    .opacity(showStats ? 1 : 0)
                }

                Spacer()
            }
            .storyCardStyle()

            // Confetti overlay
            if showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.3)) {
                showStats = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showConfetti = true
                HapticManager.milestone()
            }
        }
    }
}

struct SummaryStatBox: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let delay: Double
    let show: Bool
    var isText: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)

            if isText {
                Text(value)
                    .font(Typography.bodyBold)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            } else {
                Text(value)
                    .font(Typography.cardSubtitle)
                    .foregroundStyle(LoopedTheme.primaryText)
            }

            Text(label)
                .font(Typography.caption)
                .foregroundStyle(LoopedTheme.tertiaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
        .opacity(show ? 1 : 0)
        .scaleEffect(show ? 1 : 0.8)
        .animation(LoopedTheme.defaultAnimation.delay(delay), value: show)
    }
}

struct ShareButton: View {
    let stats: ListeningStats
    @State private var isPressed = false

    var body: some View {
        Button(action: shareStats) {
            HStack(spacing: 12) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .semibold))

                Text("Share Your Wrapped")
                    .font(Typography.buttonLarge)
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(Color.white)
            )
            .scaleEffect(isPressed ? 0.95 : 1)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }

    private func shareStats() {
        HapticManager.impact(.medium)

        let shareText = """
        My \(stats.year) Apple Music Wrapped:

        \(stats.totalHours) hours of music
        \(stats.totalSongsPlayed.formatted()) songs played
        Top artist: \(stats.topArtists.first?.name ?? "Unknown")

        Generated with Looped
        """

        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    ZStack {
        MeshGradientBackground(colors: LoopedTheme.celebrationGradient)
        SummaryCard(stats: .sample)
    }
}
