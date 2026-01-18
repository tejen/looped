//
//  Color+Extensions.swift
//  Looped
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    func lighter(by amount: Double = 0.2) -> Color {
        self.adjust(by: amount)
    }

    func darker(by amount: Double = 0.2) -> Color {
        self.adjust(by: -amount)
    }

    private func adjust(by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newBrightness = max(0, min(1, brightness + CGFloat(amount)))

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(newBrightness), opacity: Double(alpha))
    }

    func saturated(by amount: Double = 0.2) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        let newSaturation = max(0, min(1, saturation + CGFloat(amount)))

        return Color(hue: Double(hue), saturation: Double(newSaturation), brightness: Double(brightness), opacity: Double(alpha))
    }
}
