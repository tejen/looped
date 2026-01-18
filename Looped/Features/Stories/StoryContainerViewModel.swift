//
//  StoryContainerViewModel.swift
//  Looped
//

import SwiftUI
import Observation

@Observable
final class StoryContainerViewModel {
    var currentCardIndex: Int = 0
    var stats: ListeningStats
    var isLoading: Bool = false
    var currentColors: [Color] = LoopedTheme.defaultGradient
    var cardProgress: Double = 0

    private var autoAdvanceTimer: Timer?
    private let autoAdvanceInterval: TimeInterval = 6.0

    let totalCards = 8

    init(stats: ListeningStats = .sample) {
        self.stats = stats
        updateColorsForCurrentCard()
    }

    func advanceToNextCard() {
        guard currentCardIndex < totalCards - 1 else { return }
        HapticManager.cardTransition()
        withAnimation(LoopedTheme.defaultAnimation) {
            currentCardIndex += 1
            cardProgress = 0
        }
        updateColorsForCurrentCard()
    }

    func goToPreviousCard() {
        guard currentCardIndex > 0 else { return }
        HapticManager.cardTransition()
        withAnimation(LoopedTheme.defaultAnimation) {
            currentCardIndex -= 1
            cardProgress = 0
        }
        updateColorsForCurrentCard()
    }

    func goToCard(_ index: Int) {
        guard index >= 0 && index < totalCards else { return }
        HapticManager.cardTransition()
        withAnimation(LoopedTheme.defaultAnimation) {
            currentCardIndex = index
            cardProgress = 0
        }
        updateColorsForCurrentCard()
    }

    func updateColorsForCurrentCard() {
        withAnimation(.easeInOut(duration: 0.8)) {
            switch currentCardIndex {
            case 0: // Welcome
                currentColors = LoopedTheme.welcomeGradient
            case 1: // Total Time
                currentColors = [
                    Color(red: 0.1, green: 0.3, blue: 0.5),
                    Color(red: 0.2, green: 0.1, blue: 0.4),
                    Color(red: 0.1, green: 0.2, blue: 0.3)
                ]
            case 2: // Top Artist
                if let artist = stats.topArtists.first {
                    currentColors = colorsForArtist(artist)
                } else {
                    currentColors = LoopedTheme.defaultGradient
                }
            case 3: // Top Songs
                currentColors = [
                    Color(red: 0.8, green: 0.3, blue: 0.4),
                    Color(red: 0.6, green: 0.2, blue: 0.5),
                    Color(red: 0.4, green: 0.2, blue: 0.6)
                ]
            case 4: // Top Genres
                if let genre = stats.topGenres.first {
                    currentColors = [
                        genre.color,
                        genre.color.darker(by: 0.3),
                        Color.black.opacity(0.8)
                    ]
                } else {
                    currentColors = LoopedTheme.defaultGradient
                }
            case 5: // Listening Patterns
                currentColors = [
                    Color(red: 0.2, green: 0.3, blue: 0.6),
                    Color(red: 0.1, green: 0.2, blue: 0.4),
                    Color(red: 0.15, green: 0.15, blue: 0.3)
                ]
            case 6: // Audio Aura
                currentColors = stats.audioAura.colors
            case 7: // Summary
                currentColors = LoopedTheme.celebrationGradient
            default:
                currentColors = LoopedTheme.defaultGradient
            }
        }
    }

    private func colorsForArtist(_ artist: ArtistStats) -> [Color] {
        // Generate colors based on genres
        if let primaryGenre = artist.genres.first {
            let genreStat = GenreStats(id: "temp", name: primaryGenre, playCount: 0, percentage: 0)
            return [
                genreStat.color,
                genreStat.color.darker(by: 0.3),
                Color.black.opacity(0.8)
            ]
        }
        return LoopedTheme.defaultGradient
    }

    func startAutoAdvance() {
        stopAutoAdvance()
        autoAdvanceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.cardProgress += 0.1 / self.autoAdvanceInterval
            if self.cardProgress >= 1.0 {
                self.advanceToNextCard()
            }
        }
    }

    func stopAutoAdvance() {
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = nil
    }

    func handleTap(at location: CGPoint, in size: CGSize) {
        let tapZone = size.width / 3

        if location.x < tapZone {
            goToPreviousCard()
        } else if location.x > size.width - tapZone {
            advanceToNextCard()
        }
        // Middle zone does nothing (could pause/play)
    }

    func handleDragEnd(translation: CGFloat) {
        if translation < -50 {
            advanceToNextCard()
        } else if translation > 50 {
            goToPreviousCard()
        }
    }
}
