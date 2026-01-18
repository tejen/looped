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
                        Text("Your \(stats.year.unformatted)")
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
    @State private var shareImage: Image?

    var body: some View {
        if let shareImage {
            ShareLink(
                item: shareImage,
                preview: SharePreview("My \(stats.year.unformatted) Wrapped", image: shareImage)
            ) {
                shareButtonLabel
            }
            .buttonStyle(.plain)
        } else {
            Button(action: generateAndShare) {
                shareButtonLabel
            }
            .buttonStyle(.plain)
        }
    }

    private var shareButtonLabel: some View {
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
    }

    private func generateAndShare() {
        let renderer = ImageRenderer(content: ShareableCard(stats: stats))
        renderer.scale = 3.0

        if let uiImage = renderer.uiImage {
            shareImage = Image(uiImage: uiImage)
        }
    }
}

// Custom view designed for sharing as an image
struct ShareableCard: View {
    let stats: ListeningStats

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("My \(stats.year.unformatted)")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))

                Text("Wrapped")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }

            // Stats grid
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    ShareStatBox(icon: "clock.fill", value: "\(stats.totalHours)", label: "hours")
                    ShareStatBox(icon: "music.note.list", value: "\(stats.totalSongsPlayed.formatted())", label: "songs")
                }
                HStack(spacing: 12) {
                    ShareStatBox(icon: "person.2.fill", value: "\(stats.totalArtistsDiscovered)", label: "artists")
                    ShareStatBox(icon: "star.fill", value: stats.topArtists.first?.name ?? "-", label: "#1 artist", isText: true)
                }
            }

            // Top songs
            if !stats.topSongs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Top Songs")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))

                    ForEach(Array(stats.topSongs.prefix(3).enumerated()), id: \.element.id) { index, song in
                        HStack(spacing: 12) {
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.5))
                                .frame(width: 20)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(song.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                Text(song.artistName)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white.opacity(0.7))
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white.opacity(0.1))
                )
            }

            // Branding
            HStack(spacing: 6) {
                Image(systemName: "music.note")
                Text("Looped")
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.5))
        }
        .padding(32)
        .frame(width: 360)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.6, green: 0.2, blue: 0.5),
                    Color(red: 0.3, green: 0.2, blue: 0.6),
                    Color(red: 0.2, green: 0.3, blue: 0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

struct ShareStatBox: View {
    let icon: String
    let value: String
    let label: String
    var isText: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.white)

            Text(value)
                .font(.system(size: isText ? 16 : 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white.opacity(0.1))
        )
    }
}

#Preview {
    ZStack {
        MeshGradientBackground(colors: LoopedTheme.celebrationGradient)
        SummaryCard(stats: .sample)
    }
}
