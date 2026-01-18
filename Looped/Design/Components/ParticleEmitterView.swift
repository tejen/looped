//
//  ParticleEmitterView.swift
//  Looped
//

import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
    var delay: Double
    var color: Color
}

struct ParticleEmitterView: View {
    let colors: [Color]
    let particleCount: Int

    @State private var particles: [Particle] = []
    @State private var isAnimating = false

    init(colors: [Color] = [.white], particleCount: Int = 30) {
        self.colors = colors
        self.particleCount = particleCount
    }

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1/30)) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate

                    for particle in particles {
                        let yOffset = CGFloat(time.truncatingRemainder(dividingBy: 20 + particle.delay)) * particle.speed * 10
                        let adjustedY = (particle.y - yOffset).truncatingRemainder(dividingBy: size.height + 50)
                        let finalY = adjustedY < 0 ? size.height + adjustedY : adjustedY

                        let xWobble = sin(time * 2 + particle.delay) * 20

                        let opacity = particle.opacity * (0.5 + 0.5 * sin(time * 3 + particle.delay))

                        context.opacity = opacity
                        context.fill(
                            Circle().path(in: CGRect(
                                x: particle.x + xWobble - particle.size / 2,
                                y: finalY - particle.size / 2,
                                width: particle.size,
                                height: particle.size
                            )),
                            with: .color(particle.color)
                        )
                    }
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }

    private func generateParticles(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            Particle(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 2...6),
                opacity: Double.random(in: 0.2...0.6),
                speed: CGFloat.random(in: 0.5...2),
                delay: Double.random(in: 0...10),
                color: colors.randomElement() ?? .white
            )
        }
    }
}

struct ConfettiView: View {
    @State private var isAnimating = false

    let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<50) { index in
                    ConfettiPiece(
                        color: colors[index % colors.count],
                        size: geometry.size,
                        delay: Double(index) * 0.02
                    )
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct ConfettiPiece: View {
    let color: Color
    let size: CGSize
    let delay: Double

    @State private var isAnimating = false

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: CGFloat.random(in: 8...12), height: CGFloat.random(in: 8...16))
            .position(
                x: CGFloat.random(in: 0...size.width),
                y: isAnimating ? size.height + 50 : -50
            )
            .rotationEffect(.degrees(isAnimating ? Double.random(in: 360...720) : 0))
            .opacity(isAnimating ? 0 : 1)
            .animation(
                .easeIn(duration: Double.random(in: 2...4)).delay(delay),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    ZStack {
        Color.black
        ParticleEmitterView(colors: [.white, .white.opacity(0.5)], particleCount: 40)
    }
}
