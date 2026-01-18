//
//  GradientBackground.swift
//  Looped
//

import SwiftUI

struct GradientBackground: View {
    let colors: [Color]
    @State private var startPoint: UnitPoint = .topLeading
    @State private var endPoint: UnitPoint = .bottomTrailing

    var body: some View {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    startPoint = .bottomLeading
                    endPoint = .topTrailing
                }
            }
    }
}

struct MeshGradientBackground: View {
    let colors: [Color]

    private var expandedColors: [Color] {
        var result: [Color] = []
        for i in 0..<9 {
            result.append(colors[i % colors.count])
        }
        return result
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let points = computePoints(time: time)

            ZStack {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: points,
                    colors: expandedColors
                )

                // Subtle vignette for depth
                RadialGradient(
                    colors: [.clear, .black.opacity(0.3)],
                    center: .center,
                    startRadius: 200,
                    endRadius: 600
                )
            }
        }
        .ignoresSafeArea()
    }

    private func computePoints(time: Double) -> [SIMD2<Float>] {
        let t = Float(time)
        return [
            SIMD2(0.0, 0.0),
            SIMD2(0.5 + sin(t * 0.5) * 0.1, 0.0),
            SIMD2(1.0, 0.0),
            SIMD2(0.0, 0.5 + cos(t * 0.3) * 0.1),
            SIMD2(0.5 + sin(t * 0.7) * 0.15, 0.5 + cos(t * 0.4) * 0.15),
            SIMD2(1.0, 0.5 + sin(t * 0.6) * 0.1),
            SIMD2(0.0, 1.0),
            SIMD2(0.5 + cos(t * 0.4) * 0.1, 1.0),
            SIMD2(1.0, 1.0)
        ]
    }
}

struct StaticGradientBackground: View {
    let colors: [Color]

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    MeshGradientBackground(colors: LoopedTheme.defaultGradient)
}
