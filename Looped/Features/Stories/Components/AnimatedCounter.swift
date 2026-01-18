//
//  AnimatedCounter.swift
//  Looped
//

import SwiftUI

struct AnimatedCounter: View {
    let value: Int
    let duration: Double
    let font: Font
    let color: Color

    @State private var displayValue: Int = 0
    @State private var hasAnimated = false

    init(
        value: Int,
        duration: Double = 1.5,
        font: Font = Typography.statNumber,
        color: Color = LoopedTheme.primaryText
    ) {
        self.value = value
        self.duration = duration
        self.font = font
        self.color = color
    }

    var body: some View {
        Text(formattedValue)
            .font(font)
            .foregroundStyle(color)
            .contentTransition(.numericText())
            .onAppear {
                guard !hasAnimated else { return }
                hasAnimated = true
                animateValue()
            }
    }

    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: displayValue)) ?? "\(displayValue)"
    }

    private func animateValue() {
        let steps = 60
        let stepDuration = duration / Double(steps)
        let increment = Double(value) / Double(steps)

        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                withAnimation(.easeOut(duration: stepDuration)) {
                    if step == steps {
                        displayValue = value
                    } else {
                        displayValue = Int(increment * Double(step))
                    }
                }
            }
        }
    }
}

struct AnimatedTimeCounter: View {
    let totalMinutes: Int
    let duration: Double

    @State private var displayMinutes: Int = 0
    @State private var hasAnimated = false

    init(totalMinutes: Int, duration: Double = 2.0) {
        self.totalMinutes = totalMinutes
        self.duration = duration
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(displayHours)")
                    .font(Typography.statNumber)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .contentTransition(.numericText())

                Text("hrs")
                    .font(Typography.statUnit)
                    .foregroundStyle(LoopedTheme.secondaryText)
            }

            if displayRemainingMinutes > 0 {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(displayRemainingMinutes)")
                        .font(Typography.heroSubtitle)
                        .foregroundStyle(LoopedTheme.primaryText)
                        .contentTransition(.numericText())

                    Text("min")
                        .font(Typography.cardSubtitle)
                        .foregroundStyle(LoopedTheme.secondaryText)
                }
            }
        }
        .onAppear {
            guard !hasAnimated else { return }
            hasAnimated = true
            animateValue()
        }
    }

    private var displayHours: Int {
        displayMinutes / 60
    }

    private var displayRemainingMinutes: Int {
        displayMinutes % 60
    }

    private func animateValue() {
        let steps = 80
        let stepDuration = duration / Double(steps)
        let increment = Double(totalMinutes) / Double(steps)

        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                withAnimation(.easeOut(duration: stepDuration)) {
                    if step == steps {
                        displayMinutes = totalMinutes
                    } else {
                        displayMinutes = Int(increment * Double(step))
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VStack(spacing: 40) {
            AnimatedCounter(value: 42680)
            AnimatedTimeCounter(totalMinutes: 42680)
        }
    }
}
