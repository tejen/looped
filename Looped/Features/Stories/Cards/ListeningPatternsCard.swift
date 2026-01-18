//
//  ListeningPatternsCard.swift
//  Looped
//

import SwiftUI

struct ListeningPatternsCard: View {
    let patterns: ListeningPatterns
    @State private var isVisible = false
    @State private var showChart = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    Text("When You Listen")
                        .font(Typography.cardTitle)
                        .foregroundStyle(LoopedTheme.primaryText)

                    Text("Your peak listening time")
                        .font(Typography.body)
                        .foregroundStyle(LoopedTheme.secondaryText)
                }
                .opacity(isVisible ? 1 : 0)

                // Peak time highlight
                VStack(spacing: 12) {
                    Text(patterns.peakTimeDescription)
                        .font(Typography.heroSubtitle)
                        .foregroundStyle(LoopedTheme.primaryText)

                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(LoopedTheme.secondaryText)
                        Text("Peak at \(patterns.formattedPeakHour)")
                            .font(Typography.body)
                            .foregroundStyle(LoopedTheme.secondaryText)
                    }
                }
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.9)

                // Hour chart
                HourlyChart(distribution: patterns.hourlyDistribution, showChart: showChart)
                    .frame(height: 120)
                    .padding(.horizontal, 8)

                // Weekday info
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundStyle(LoopedTheme.secondaryText)
                    Text("Most active on \(patterns.peakWeekdayName)s")
                        .font(Typography.body)
                        .foregroundStyle(LoopedTheme.secondaryText)
                }
                .opacity(isVisible ? 1 : 0)
            }

            Spacer()
        }
        .storyCardStyle()
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.4)) {
                showChart = true
            }
        }
    }
}

struct HourlyChart: View {
    let distribution: [Int: Int]
    let showChart: Bool

    private var maxValue: Int {
        distribution.values.max() ?? 1
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(0..<24, id: \.self) { hour in
                    VStack(spacing: 4) {
                        // Bar
                        RoundedRectangle(cornerRadius: 2)
                            .fill(barColor(for: hour))
                            .frame(height: showChart ? barHeight(for: hour, maxHeight: geometry.size.height - 20) : 0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.7).delay(Double(hour) * 0.02),
                                value: showChart
                            )

                        // Label (only for key hours)
                        if hour % 6 == 0 {
                            Text(hourLabel(for: hour))
                                .font(.system(size: 9))
                                .foregroundStyle(LoopedTheme.tertiaryText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func barHeight(for hour: Int, maxHeight: CGFloat) -> CGFloat {
        let value = distribution[hour] ?? 0
        guard maxValue > 0 else { return 4 }
        return max(4, CGFloat(value) / CGFloat(maxValue) * maxHeight)
    }

    private func barColor(for hour: Int) -> Color {
        let value = distribution[hour] ?? 0
        let intensity = Double(value) / Double(maxValue)

        if hour >= 20 || hour < 6 {
            return Color(red: 0.4, green: 0.3, blue: 0.8).opacity(0.5 + intensity * 0.5)
        } else if hour >= 6 && hour < 12 {
            return Color(red: 1.0, green: 0.7, blue: 0.3).opacity(0.5 + intensity * 0.5)
        } else {
            return Color(red: 0.3, green: 0.7, blue: 0.9).opacity(0.5 + intensity * 0.5)
        }
    }

    private func hourLabel(for hour: Int) -> String {
        switch hour {
        case 0: return "12a"
        case 6: return "6a"
        case 12: return "12p"
        case 18: return "6p"
        default: return ""
        }
    }
}

#Preview {
    ZStack {
        Color.black
        ListeningPatternsCard(patterns: ListeningStats.sample.listeningPatterns)
    }
}
