//
//  LoopedTheme.swift
//  Looped
//

import SwiftUI

enum LoopedTheme {
    // MARK: - Colors
    static let background = Color.black
    static let cardBackground = Color.white.opacity(0.08)
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.7)
    static let tertiaryText = Color.white.opacity(0.5)

    // MARK: - Gradients
    static let defaultGradient: [Color] = [
        Color(red: 0.4, green: 0.2, blue: 0.8),
        Color(red: 0.8, green: 0.3, blue: 0.5),
        Color(red: 0.2, green: 0.5, blue: 0.8)
    ]

    static let welcomeGradient: [Color] = [
        Color(red: 0.1, green: 0.1, blue: 0.2),
        Color(red: 0.2, green: 0.1, blue: 0.3),
        Color(red: 0.1, green: 0.2, blue: 0.3)
    ]

    static let celebrationGradient: [Color] = [
        Color(red: 1.0, green: 0.4, blue: 0.3),
        Color(red: 0.9, green: 0.2, blue: 0.5),
        Color(red: 0.6, green: 0.2, blue: 0.8)
    ]

    // MARK: - Spacing
    static let cardPadding: CGFloat = 24
    static let elementSpacing: CGFloat = 16
    static let largeSpacing: CGFloat = 32
    static let smallSpacing: CGFloat = 8

    // MARK: - Corner Radius
    static let cardRadius: CGFloat = 24
    static let buttonRadius: CGFloat = 16
    static let smallRadius: CGFloat = 12

    // MARK: - Shadows
    static let cardShadow = Color.black.opacity(0.3)
    static let glowOpacity: Double = 0.6

    // MARK: - Animation
    static let defaultAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.8)
    static let quickAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7)
    static let slowAnimation: Animation = .spring(response: 0.7, dampingFraction: 0.8)
    static let cardTransitionDuration: Double = 0.4

    // MARK: - Progress Bar
    static let progressBarHeight: CGFloat = 3
    static let progressBarSpacing: CGFloat = 4
    static let progressBarBackground = Color.white.opacity(0.3)
    static let progressBarFill = Color.white
}
