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
    @State private var phase: Double = 0

    private var expandedColors: [Color] {
        // MeshGradient needs 9 colors for 3x3 grid
        var result: [Color] = []
        for i in 0..<9 {
            result.append(colors[i % colors.count])
        }
        return result
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5 + Float(sin(time * 0.5)) * 0.1, 0.0], [1.0, 0.0],
                    [0.0, 0.5 + Float(cos(time * 0.3)) * 0.1], [0.5 + Float(sin(time * 0.7)) * 0.15, 0.5 + Float(cos(time * 0.4)) * 0.15], [1.0, 0.5 + Float(sin(time * 0.6)) * 0.1],
                    [0.0, 1.0], [0.5 + Float(cos(time * 0.4)) * 0.1, 1.0], [1.0, 1.0]
                ],
                colors: expandedColors
            )
        }
        .ignoresSafeArea()
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
