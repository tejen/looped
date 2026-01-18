//
//  StoryProgressBar.swift
//  Looped
//

import SwiftUI

struct StoryProgressBar: View {
    let totalCards: Int
    let currentIndex: Int
    let cardProgress: Double

    var body: some View {
        HStack(spacing: LoopedTheme.progressBarSpacing) {
            ForEach(0..<totalCards, id: \.self) { index in
                ProgressSegment(
                    progress: progressForSegment(at: index),
                    isActive: index == currentIndex
                )
            }
        }
        .padding(.horizontal, LoopedTheme.cardPadding)
        .padding(.top, 12)
    }

    private func progressForSegment(at index: Int) -> Double {
        if index < currentIndex {
            return 1.0
        } else if index == currentIndex {
            return cardProgress
        } else {
            return 0.0
        }
    }
}

struct ProgressSegment: View {
    let progress: Double
    let isActive: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: LoopedTheme.progressBarHeight / 2)
                    .fill(LoopedTheme.progressBarBackground)

                // Fill
                RoundedRectangle(cornerRadius: LoopedTheme.progressBarHeight / 2)
                    .fill(LoopedTheme.progressBarFill)
                    .frame(width: geometry.size.width * progress)
                    .animation(isActive ? .linear(duration: 0.1) : .none, value: progress)
            }
        }
        .frame(height: LoopedTheme.progressBarHeight)
    }
}

#Preview {
    ZStack {
        Color.black
        VStack {
            StoryProgressBar(totalCards: 8, currentIndex: 2, cardProgress: 0.5)
            Spacer()
        }
    }
}
