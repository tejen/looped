//
//  Typography.swift
//  Looped
//

import SwiftUI

enum Typography {
    // MARK: - Hero Titles
    static let heroTitle = Font.system(size: 72, weight: .black, design: .rounded)
    static let heroSubtitle = Font.system(size: 48, weight: .bold, design: .rounded)

    // MARK: - Card Titles
    static let cardTitle = Font.system(size: 32, weight: .bold, design: .default)
    static let cardSubtitle = Font.system(size: 24, weight: .semibold, design: .default)

    // MARK: - Statistics
    static let statNumber = Font.system(size: 80, weight: .heavy, design: .rounded)
    static let statLabel = Font.system(size: 18, weight: .medium, design: .default)
    static let statUnit = Font.system(size: 36, weight: .bold, design: .rounded)

    // MARK: - Body Text
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
    static let bodyLarge = Font.system(size: 20, weight: .medium, design: .default)

    // MARK: - Captions
    static let caption = Font.system(size: 14, weight: .regular, design: .default)
    static let captionBold = Font.system(size: 14, weight: .semibold, design: .default)

    // MARK: - Rankings
    static let rankNumber = Font.system(size: 24, weight: .black, design: .rounded)
    static let rankTitle = Font.system(size: 18, weight: .semibold, design: .default)
    static let rankSubtitle = Font.system(size: 14, weight: .regular, design: .default)

    // MARK: - Buttons
    static let button = Font.system(size: 16, weight: .semibold, design: .default)
    static let buttonLarge = Font.system(size: 18, weight: .bold, design: .default)
}

// MARK: - Text Styles
extension View {
    func heroTitleStyle() -> some View {
        self
            .font(Typography.heroTitle)
            .foregroundStyle(LoopedTheme.primaryText)
    }

    func cardTitleStyle() -> some View {
        self
            .font(Typography.cardTitle)
            .foregroundStyle(LoopedTheme.primaryText)
    }

    func statNumberStyle() -> some View {
        self
            .font(Typography.statNumber)
            .foregroundStyle(LoopedTheme.primaryText)
    }

    func bodyStyle() -> some View {
        self
            .font(Typography.body)
            .foregroundStyle(LoopedTheme.secondaryText)
    }

    func captionStyle() -> some View {
        self
            .font(Typography.caption)
            .foregroundStyle(LoopedTheme.tertiaryText)
    }
}
