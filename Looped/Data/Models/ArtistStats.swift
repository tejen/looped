//
//  ArtistStats.swift
//  Looped
//

import Foundation

struct ArtistStats: Identifiable, Sendable {
    let id: String
    let name: String
    let artworkURL: URL?
    let playCount: Int
    let totalPlayTime: TimeInterval
    let topSongTitle: String?
    let genres: [String]

    var formattedPlayCount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: playCount)) ?? "\(playCount)"
    }

    var formattedPlayTime: String {
        let hours = Int(totalPlayTime) / 3600
        let minutes = (Int(totalPlayTime) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes) minutes"
    }
}
