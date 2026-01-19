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
        ZStack {
            // Animated background (ignores safe area)
            MeshGradientBackground(colors: viewModel.currentColors)
                .ignoresSafeArea()

            // Particles overlay (ignores safe area)
            ParticleEmitterView(
                colors: [.white.opacity(0.6), .white.opacity(0.4)],
                particleCount: 40
            )
            .ignoresSafeArea()

            // Story content (respects safe area)
            VStack(spacing: 0) {
                // Progress bar
                StoryProgressBar(
                    totalCards: viewModel.totalCards,
                    currentIndex: viewModel.currentCardIndex,
                    cardProgress: viewModel.cardProgress
                )
                .padding(.top, 8)

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

                    SummaryCard(stats: viewModel.stats) {
                        viewModel.goToCard(0)
                    }
                        .tag(7)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: viewModel.currentCardIndex) { _, newValue in
                    viewModel.updateColorsForCurrentCard()
                }
            }

        }
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
