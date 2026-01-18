//
//  AudioAura.swift
//  Looped
//

import Foundation
import SwiftUI

struct AudioAura: Sendable {
    let primaryMood: Mood
    let secondaryMood: Mood
    let description: String

    var colors: [Color] {
        [primaryMood.color, secondaryMood.color, primaryMood.color.opacity(0.6)]
    }

    enum Mood: String, CaseIterable, Sendable {
        case energetic = "Energetic"
        case melancholic = "Melancholic"
        case chill = "Chill"
        case intense = "Intense"
        case dreamy = "Dreamy"
        case uplifting = "Uplifting"
        case bold = "Bold"
        case introspective = "Introspective"

        var color: Color {
            switch self {
            case .energetic:
                return Color(red: 1.0, green: 0.4, blue: 0.2)
            case .melancholic:
                return Color(red: 0.4, green: 0.4, blue: 0.8)
            case .chill:
                return Color(red: 0.3, green: 0.8, blue: 0.7)
            case .intense:
                return Color(red: 0.8, green: 0.1, blue: 0.3)
            case .dreamy:
                return Color(red: 0.7, green: 0.5, blue: 0.9)
            case .uplifting:
                return Color(red: 1.0, green: 0.8, blue: 0.2)
            case .bold:
                return Color(red: 0.9, green: 0.2, blue: 0.5)
            case .introspective:
                return Color(red: 0.3, green: 0.5, blue: 0.7)
            }
        }

        var emoji: String {
            switch self {
            case .energetic: return "lightning.bolt"
            case .melancholic: return "cloud.rain"
            case .chill: return "leaf"
            case .intense: return "flame"
            case .dreamy: return "moon.stars"
            case .uplifting: return "sun.max"
            case .bold: return "star.fill"
            case .introspective: return "heart"
            }
        }
    }

    static func generate(from genres: [GenreStats]) -> AudioAura {
        var moodScores: [Mood: Double] = [:]

        for genre in genres {
            let moods = genreToMoods(genre.name)
            for mood in moods {
                moodScores[mood, default: 0] += genre.percentage
            }
        }

        let sortedMoods = moodScores.sorted { $0.value > $1.value }
        let primary = sortedMoods.first?.key ?? .chill
        let secondary = sortedMoods.dropFirst().first?.key ?? .dreamy

        let description = generateDescription(primary: primary, secondary: secondary)

        return AudioAura(primaryMood: primary, secondaryMood: secondary, description: description)
    }

    private static func genreToMoods(_ genre: String) -> [Mood] {
        let lowercased = genre.lowercased()
        switch lowercased {
        case let g where g.contains("pop"):
            return [.uplifting, .energetic]
        case let g where g.contains("hip") || g.contains("rap"):
            return [.bold, .energetic]
        case let g where g.contains("rock"):
            return [.intense, .bold]
        case let g where g.contains("r&b") || g.contains("soul"):
            return [.chill, .introspective]
        case let g where g.contains("electronic") || g.contains("dance"):
            return [.energetic, .bold]
        case let g where g.contains("jazz"):
            return [.chill, .dreamy]
        case let g where g.contains("classical"):
            return [.introspective, .melancholic]
        case let g where g.contains("indie") || g.contains("alternative"):
            return [.dreamy, .introspective]
        case let g where g.contains("metal"):
            return [.intense, .bold]
        case let g where g.contains("country"):
            return [.uplifting, .melancholic]
        default:
            return [.chill]
        }
    }

    private static func generateDescription(primary: Mood, secondary: Mood) -> String {
        switch (primary, secondary) {
        case (.energetic, .bold):
            return "Your music radiates unstoppable energy. You're the life of the party, always ready to turn up the volume and seize the moment."
        case (.chill, .dreamy):
            return "You find peace in the ethereal. Your playlist is a sanctuary of calm, perfect for late-night contemplation and peaceful moments."
        case (.intense, .bold):
            return "You don't just listen to music—you feel it in your bones. Your taste is fierce, unapologetic, and impossible to ignore."
        case (.uplifting, .energetic):
            return "Sunshine in audio form. Your music choices spread positivity and keep the good vibes flowing all year long."
        case (.introspective, .melancholic):
            return "A thoughtful soul with depth. Your music reflects your rich inner world and appreciation for emotional complexity."
        case (.dreamy, .introspective):
            return "You're a daydreamer with impeccable taste. Your playlist paints pictures of starlit skies and quiet moments of wonder."
        case (.bold, .intense):
            return "Fearless and powerful. Your music hits hard and makes a statement—just like you."
        default:
            return "Your unique blend of \(primary.rawValue.lowercased()) and \(secondary.rawValue.lowercased()) vibes creates a sound that's distinctly you."
        }
    }
}
