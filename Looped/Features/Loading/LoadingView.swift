//
//  LoadingView.swift
//  Looped
//

import SwiftUI

struct LoadingView: View {
    @Binding var stats: ListeningStats?
    @Binding var isLoading: Bool
    var onError: ((String) -> Void)?
    var onEmptyLibrary: (() -> Void)?
    @State private var progress: Double = 0
    @State private var currentPhase = 0
    @State private var showPhaseText = false

    private let phases = [
        "Connecting to Apple Music...",
        "Analyzing your library...",
        "Calculating your top songs...",
        "Finding your favorite artists...",
        "Generating your Audio Aura...",
        "Preparing your experience..."
    ]

    var body: some View {
        ZStack {
            // Background
            MeshGradientBackground(colors: LoopedTheme.defaultGradient)

            VStack(spacing: 40) {
                Spacer()

                // Animated loader
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 4)
                        .frame(width: 120, height: 120)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))

                    // Center icon
                    Image(systemName: "waveform")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse, options: .repeating)
                }

                // Phase text
                VStack(spacing: 12) {
                    Text(phases[currentPhase])
                        .font(Typography.bodyBold)
                        .foregroundStyle(LoopedTheme.primaryText)
                        .opacity(showPhaseText ? 1 : 0)
                        .id(currentPhase)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))

                    Text("\(Int(progress * 100))%")
                        .font(Typography.caption)
                        .foregroundStyle(LoopedTheme.secondaryText)
                }

                Spacer()

                // Tip
                VStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(.yellow.opacity(0.8))
                    Text("Tip: Use Looped regularly to track your music journey")
                        .font(Typography.caption)
                        .foregroundStyle(LoopedTheme.tertiaryText)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startLoading()
        }
    }

    private func startLoading() {
        showPhaseText = true

        // Animate through phases
        Task {
            for (index, _) in phases.enumerated() {
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showPhaseText = false
                    }
                }

                try? await Task.sleep(nanoseconds: 100_000_000)

                await MainActor.run {
                    currentPhase = index
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showPhaseText = true
                        progress = Double(index + 1) / Double(phases.count)
                    }
                }

                // Simulate work
                try? await Task.sleep(nanoseconds: 600_000_000)
            }

            // Load actual stats
            await loadStats()
        }
    }

    private func loadStats() async {
        do {
            let songs = try await MusicKitService.shared.fetchLibrarySongs()

            // Check for empty library
            let songsWithPlays = songs.filter { $0.playCount > 0 }
            if songsWithPlays.isEmpty {
                await MainActor.run {
                    onEmptyLibrary?()
                }
                return
            }

            let calculatedStats = await StatsCalculationEngine.shared.calculateStats(from: songs)

            await MainActor.run {
                stats = calculatedStats
                withAnimation {
                    isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                onError?("We couldn't load your music data. Please check your internet connection and try again.")
            }
        }
    }
}

struct PulsingLoader: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.3 - Double(index) * 0.1))
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 1.5 + CGFloat(index) * 0.3 : 1)
                    .opacity(isAnimating ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.3),
                        value: isAnimating
                    )
            }

            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 60)

            Image(systemName: "music.note")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView(stats: .constant(nil), isLoading: .constant(true))
}
