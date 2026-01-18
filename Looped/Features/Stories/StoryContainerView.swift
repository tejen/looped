//
//  StoryContainerView.swift
//  Looped
//

import SwiftUI

struct StoryContainerView: View {
    @State private var viewModel: StoryContainerViewModel

    init(stats: ListeningStats = .sample) {
        _viewModel = State(initialValue: StoryContainerViewModel(stats: stats))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated background
                MeshGradientBackground(colors: viewModel.currentColors)

                // Particles overlay
                ParticleEmitterView(
                    colors: [.white.opacity(0.3), .white.opacity(0.1)],
                    particleCount: 25
                )

                // Story content
                VStack(spacing: 0) {
                    // Progress bar
                    StoryProgressBar(
                        totalCards: viewModel.totalCards,
                        currentIndex: viewModel.currentCardIndex,
                        cardProgress: viewModel.cardProgress
                    )

                    // Card content
                    TabView(selection: $viewModel.currentCardIndex) {
                        WelcomeCard(year: viewModel.stats.year)
                            .tag(0)

                        TotalTimeCard(stats: viewModel.stats)
                            .tag(1)

                        TopArtistCard(artist: viewModel.stats.topArtists.first)
                            .tag(2)

                        TopSongsCard(songs: viewModel.stats.topSongs)
                            .tag(3)

                        TopGenresCard(genres: viewModel.stats.topGenres)
                            .tag(4)

                        ListeningPatternsCard(patterns: viewModel.stats.listeningPatterns)
                            .tag(5)

                        AudioAuraCard(aura: viewModel.stats.audioAura)
                            .tag(6)

                        SummaryCard(stats: viewModel.stats)
                            .tag(7)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: viewModel.currentCardIndex) { _, newValue in
                        viewModel.updateColorsForCurrentCard()
                    }
                }

                // Tap zones overlay
                HStack(spacing: 0) {
                    // Left tap zone (go back)
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.goToPreviousCard()
                        }

                    // Middle zone (no action)
                    Color.clear
                        .contentShape(Rectangle())

                    // Right tap zone (go forward)
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.advanceToNextCard()
                        }
                }
                .allowsHitTesting(true)
            }
        }
        .ignoresSafeArea()
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    viewModel.handleDragEnd(translation: value.translation.width)
                }
        )
        .preferredColorScheme(.dark)
        .persistentSystemOverlays(.hidden)
    }
}

#Preview {
    StoryContainerView()
}
