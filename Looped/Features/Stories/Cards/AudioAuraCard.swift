//
//  AudioAuraCard.swift
//  Looped
//

import SwiftUI

struct AudioAuraCard: View {
    let aura: AudioAura
    @State private var isVisible = false
    @State private var showDescription = false
    @State private var animateBlobs = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Header
                Text("Your Audio Aura")
                    .font(Typography.cardTitle)
                    .foregroundStyle(LoopedTheme.primaryText)
                    .opacity(isVisible ? 1 : 0)

                // Aura visualization
                ZStack {
                    // Animated blobs
                    ForEach(0..<3, id: \.self) { index in
                        AuraBlob(
                            color: aura.colors[index % aura.colors.count],
                            size: CGFloat(150 - index * 20),
                            delay: Double(index) * 0.2,
                            animate: animateBlobs
                        )
                    }
                }
                .frame(width: 250, height: 250)
                .opacity(isVisible ? 1 : 0)
                .scaleEffect(isVisible ? 1 : 0.8)

                // Mood labels
                HStack(spacing: 24) {
                    MoodBadge(mood: aura.primaryMood, isPrimary: true)
                    MoodBadge(mood: aura.secondaryMood, isPrimary: false)
                }
                .opacity(isVisible ? 1 : 0)

                // Description
                Text(aura.description)
                    .font(Typography.body)
                    .foregroundStyle(LoopedTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .opacity(showDescription ? 1 : 0)
                    .offset(y: showDescription ? 0 : 20)
            }

            Spacer()
        }
        .storyCardStyle()
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation) {
                isVisible = true
                animateBlobs = true
            }
            withAnimation(LoopedTheme.defaultAnimation.delay(0.5)) {
                showDescription = true
            }
        }
    }
}

struct AuraBlob: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    let animate: Bool

    @State private var phase: CGFloat = 0

    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate + delay

            Canvas { context, canvasSize in
                let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)

                // Create animated blob shape
                var path = Path()
                let points = 8
                let angleStep = (2 * .pi) / Double(points)

                for i in 0..<points {
                    let angle = Double(i) * angleStep
                    let radiusVariation = sin(time * 2 + Double(i)) * 20
                    let radius = (size / 2) + radiusVariation

                    let x = center.x + CGFloat(cos(angle)) * radius
                    let y = center.y + CGFloat(sin(angle)) * radius

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        // Use quadratic curve for smooth blob
                        let prevAngle = Double(i - 1) * angleStep
                        let prevRadius = (size / 2) + sin(time * 2 + Double(i - 1)) * 20
                        let controlAngle = (prevAngle + angle) / 2
                        let controlRadius = (size / 2) + sin(time * 2 + Double(i) - 0.5) * 25

                        let controlX = center.x + CGFloat(cos(controlAngle)) * controlRadius
                        let controlY = center.y + CGFloat(sin(controlAngle)) * controlRadius

                        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: controlX, y: controlY))
                    }
                }
                path.closeSubpath()

                context.fill(path, with: .color(color.opacity(0.6)))
            }
        }
        .frame(width: size + 40, height: size + 40)
        .blur(radius: 20)
        .scaleEffect(animate ? 1 : 0)
        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(delay), value: animate)
    }
}

struct MoodBadge: View {
    let mood: AudioAura.Mood
    let isPrimary: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: mood.emoji)
                .font(.system(size: isPrimary ? 20 : 16))

            Text(mood.rawValue)
                .font(isPrimary ? Typography.bodyBold : Typography.body)
        }
        .foregroundStyle(mood.color)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(mood.color.opacity(0.2))
                .overlay(
                    Capsule()
                        .stroke(mood.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black
        AudioAuraCard(aura: ListeningStats.sample.audioAura)
    }
}
