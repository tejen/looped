//
//  TopGenresCard.swift
//  Looped
//

import SwiftUI

struct TopGenresCard: View {
    let genres: [GenreStats]
    @State private var isVisible = false
    @State private var showBars = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                Text("Your Top Genres")
                    .font(Typography.cardTitle)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .opacity(isVisible ? 1 : 0)

                // Genre visualization
                VStack(spacing: 20) {
                    ForEach(Array(genres.prefix(5).enumerated()), id: \.element.id) { index, genre in
                        GenreBar(
                            genre: genre,
                            maxPercentage: genres.first?.percentage ?? 100,
                            delay: Double(index) * 0.1,
                            showBar: showBars
                        )
                    }
                }
                .padding(.horizontal, 8)
            }

            Spacer()
        }
        .storyCardStyle()
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.3)) {
                showBars = true
            }
        }
    }
}

struct GenreBar: View {
    let genre: GenreStats
    let maxPercentage: Double
    let delay: Double
    let showBar: Bool

    @State private var animatedWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(genre.name)
                    .font(Typography.bodyBold)
                    .foregroundStyle(LoopedTheme.primaryText)

                Spacer()

                Text("\(Int(genre.percentage))%")
                    .font(Typography.captionBold)
                    .foregroundStyle(genre.color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))

                    // Fill
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [genre.color, genre.color.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: animatedWidth)
                }
            }
            .frame(height: 12)
        }
        .opacity(showBar ? 1 : 0)
        .offset(x: showBar ? 0 : -30)
        .onChange(of: showBar) { _, newValue in
            if newValue {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(delay)) {
                    // Calculate proportional width based on max percentage
                    let proportion = genre.percentage / maxPercentage
                    animatedWidth = UIScreen.main.bounds.width * 0.7 * CGFloat(proportion)
                }
            }
        }
    }
}

struct GenreCircles: View {
    let genres: [GenreStats]
    @State private var isVisible = false

    var body: some View {
        ZStack {
            ForEach(Array(genres.prefix(5).enumerated()), id: \.element.id) { index, genre in
                Circle()
                    .fill(genre.color.opacity(0.6))
                    .frame(width: circleSize(for: genre.percentage))
                    .offset(circleOffset(for: index))
                    .blur(radius: 2)
                    .scaleEffect(isVisible ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.1),
                        value: isVisible
                    )
            }
        }
        .onAppear {
            isVisible = true
        }
    }

    private func circleSize(for percentage: Double) -> CGFloat {
        CGFloat(60 + percentage * 1.5)
    }

    private func circleOffset(for index: Int) -> CGSize {
        let offsets: [CGSize] = [
            CGSize(width: 0, height: 0),
            CGSize(width: 80, height: -40),
            CGSize(width: -70, height: 50),
            CGSize(width: 50, height: 70),
            CGSize(width: -60, height: -60)
        ]
        return offsets[index % offsets.count]
    }
}

#Preview {
    ZStack {
        Color.black
        TopGenresCard(genres: ListeningStats.sample.topGenres)
    }
}
