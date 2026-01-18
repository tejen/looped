//
//  GenreStats.swift
//  Looped
//

import Foundation
import SwiftUI

struct GenreStats: Identifiable, Sendable {
    let id: String
    let name: String
    let playCount: Int
    let percentage: Double

    var color: Color {
        switch name.lowercased() {
        case let n where n.contains("pop"):
            return Color(red: 1.0, green: 0.4, blue: 0.6)
        case let n where n.contains("hip") || n.contains("rap"):
            return Color(red: 0.9, green: 0.3, blue: 0.2)
        case let n where n.contains("rock"):
            return Color(red: 0.6, green: 0.2, blue: 0.8)
        case let n where n.contains("r&b") || n.contains("soul"):
            return Color(red: 0.3, green: 0.6, blue: 0.9)
        case let n where n.contains("electronic") || n.contains("dance"):
            return Color(red: 0.2, green: 0.9, blue: 0.7)
        case let n where n.contains("jazz"):
            return Color(red: 0.9, green: 0.7, blue: 0.2)
        case let n where n.contains("classical"):
            return Color(red: 0.8, green: 0.6, blue: 0.4)
        case let n where n.contains("country"):
            return Color(red: 0.9, green: 0.6, blue: 0.3)
        case let n where n.contains("indie") || n.contains("alternative"):
            return Color(red: 0.5, green: 0.8, blue: 0.5)
        case let n where n.contains("metal"):
            return Color(red: 0.3, green: 0.3, blue: 0.3)
        default:
            return Color(red: 0.6, green: 0.5, blue: 0.9)
        }
    }
}
