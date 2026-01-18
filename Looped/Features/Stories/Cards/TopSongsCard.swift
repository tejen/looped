//
//  TopSongsCard.swift
//  Looped
//

import SwiftUI
import UIKit

struct TopSongsCard: View {
    let songs: [SongStats]
    @State private var visibleItems: Set<Int> = []

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // Header
                Text("Your Top Songs")
                    .font(Typography.cardTitle)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .opacity(visibleItems.contains(-1) ? 1 : 0)
                    .offset(y: visibleItems.contains(-1) ? 0 : 20)

                // Songs list
                VStack(spacing: 16) {
                    ForEach(Array(songs.prefix(5).enumerated()), id: \.element.id) { index, song in
                        SongRow(
                            rank: index + 1,
                            song: song,
                            isVisible: visibleItems.contains(index)
                        )
                    }
                }
            }

            Spacer()
        }
        .storyCardStyle()
        .onAppear {
            animateItems()
        }
    }

    private func animateItems() {
        withAnimation(LoopedTheme.defaultAnimation) {
            visibleItems.insert(-1)
        }

        for index in 0..<min(songs.count, 5) {
            withAnimation(LoopedTheme.defaultAnimation.delay(0.1 + Double(index) * 0.1)) {
                visibleItems.insert(index)
            }
        }
    }
}

struct SongRow: View {
    let rank: Int
    let song: SongStats
    let isVisible: Bool
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: 16) {
            // Rank number
            Text("\(rank)")
                .font(Typography.rankNumber)
                .foregroundStyle(rankColor)
                .frame(width: 24)

            // Album art
            AlbumArtworkView(
                url: song.artworkURL,
                size: 56,
                cornerRadius: 8,
                showShadow: false
            )

            // Song info
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(Typography.rankTitle)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .lineLimit(2)

                Text(song.artistName)
                    .font(Typography.rankSubtitle)
                    .foregroundStyle(LoopedTheme.secondaryText)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Play button
            Button {
                playTapped()
            } label: {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(LoopedTheme.primaryText)
            }
            .buttonStyle(.plain)

            // Play count
            VStack(alignment: .trailing, spacing: 2) {
                Text(song.formattedPlayCount)
                    .font(Typography.captionBold)
                    .foregroundStyle(LoopedTheme.primaryText)
                Text("plays")
                    .font(Typography.caption)
                    .foregroundStyle(LoopedTheme.tertiaryText)
            }
            .fixedSize()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : 50)
    }

    private func playTapped() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()

        if isPlaying {
            Task {
                await MusicKitService.shared.pausePlayback()
                await MainActor.run {
                    isPlaying = false
                }
            }
        } else {
            Task {
                do {
                    try await MusicKitService.shared.playSong(id: song.id)
                    await MainActor.run {
                        isPlaying = true
                    }
                } catch {
                    print("Failed to play song: \(error)")
                }
            }
        }
    }

    private var rankColor: Color {
        switch rank {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0)
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2)
        default: return LoopedTheme.secondaryText
        }
    }
}

#Preview {
    ZStack {
        Color.black
        TopSongsCard(songs: ListeningStats.sample.topSongs)
    }
}
