//
//  TotalTimeCard.swift
//  Looped
//

import SwiftUI

struct TotalTimeCard: View {
    let stats: ListeningStats
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    Text("You listened for")
                        .font(Typography.cardSubtitle)
                        .foregroundStyle(LoopedTheme.secondaryText)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 20)
                }

                // Main time counter
                AnimatedTimeCounter(totalMinutes: stats.totalMinutesListened)
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(isVisible ? 1 : 0.9)

                // Additional stats
                HStack(spacing: 40) {
                    StatItem(
                        value: "\(stats.totalSongsPlayed.formatted())",
                        label: "songs played",
                        delay: 0.4
                    )

                    StatItem(
                        value: "\(stats.totalArtistsDiscovered)",
                        label: "artists",
                        delay: 0.6
                    )
                }
                .opacity(isVisible ? 1 : 0)

                // Context
                Text(timeContext)
                    .font(Typography.body)
                    .foregroundStyle(LoopedTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
            }

            Spacer()
        }
        .storyCardStyle()
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation.delay(0.2)) {
                isVisible = true
            }
        }
    }

    private var timeContext: String {
        let hours = stats.totalMinutesListened / 60
        if hours > 1000 {
            return "That's like listening non-stop for \(hours / 24) days straight!"
        } else if hours > 500 {
            return "Impressive! You spent \(hours / 24) full days in music."
        } else if hours > 200 {
            return "You've really been vibing this year!"
        } else {
            return "Every minute counts on your musical journey."
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let delay: Double

    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(Typography.cardTitle)
                .foregroundStyle(LoopedTheme.primaryText)

            Text(label)
                .font(Typography.caption)
                .foregroundStyle(LoopedTheme.tertiaryText)
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation.delay(delay)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        TotalTimeCard(stats: .sample)
    }
}
