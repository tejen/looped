//
//  TopArtistCard.swift
//  Looped
//

import SwiftUI

struct TopArtistCard: View {
    let artist: ArtistStats?
    @State private var isVisible = false
    @State private var showDetails = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            if let artist = artist {
                VStack(spacing: 32) {
                    // Header
                    Text("Your #1 Artist")
                        .font(Typography.cardSubtitle)
                        .foregroundStyle(LoopedTheme.secondaryText)
                        .opacity(isVisible ? 1 : 0)

                    // Artist artwork
                    AlbumArtworkView(
                        url: artist.artworkURL,
                        size: 240,
                        cornerRadius: 120, // Circle for artist
                        showShadow: true
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                    )
                    .scaleEffect(isVisible ? 1 : 0.7)
                    .opacity(isVisible ? 1 : 0)

                    // Artist name
                    Text(artist.name)
                        .font(Typography.heroSubtitle)
                        .foregroundStyle(LoopedTheme.primaryText)
                        .multilineTextAlignment(.center)
                        .opacity(showDetails ? 1 : 0)
                        .offset(y: showDetails ? 0 : 20)

                    // Stats
                    VStack(spacing: 16) {
                        HStack(spacing: 32) {
                            VStack(spacing: 4) {
                                Text(artist.formattedPlayCount)
                                    .font(Typography.cardTitle)
                                    .foregroundStyle(LoopedTheme.primaryText)
                                Text("streams")
                                    .font(Typography.caption)
                                    .foregroundStyle(LoopedTheme.tertiaryText)
                            }

                            VStack(spacing: 4) {
                                Text(artist.formattedPlayTime)
                                    .font(Typography.cardTitle)
                                    .foregroundStyle(LoopedTheme.primaryText)
                                Text("listened")
                                    .font(Typography.caption)
                                    .foregroundStyle(LoopedTheme.tertiaryText)
                            }
                        }

                        if let topSong = artist.topSongTitle {
                            Text("Top track: \(topSong)")
                                .font(Typography.body)
                                .foregroundStyle(LoopedTheme.secondaryText)
                        }
                    }
                    .opacity(showDetails ? 1 : 0)
                    .offset(y: showDetails ? 0 : 20)
                }
            } else {
                Text("No artist data available")
                    .font(Typography.body)
                    .foregroundStyle(LoopedTheme.secondaryText)
            }

            Spacer()
        }
        .storyCardStyle()
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation.delay(0.1)) {
                isVisible = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.4)) {
                showDetails = true
            }
        }
    }
}

#Preview {
    ZStack {
        MeshGradientBackground(colors: LoopedTheme.defaultGradient)
        TopArtistCard(artist: ListeningStats.sample.topArtists.first)
    }
}
