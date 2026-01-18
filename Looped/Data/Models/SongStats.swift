//
//  SongStats.swift
//  Looped
//

import Foundation
import MusicKit

struct SongStats: Identifiable, Sendable {
    let id: String
    let title: String
    let artistName: String
    let albumTitle: String
    let artworkURL: URL?
    let playCount: Int
    let totalPlayTime: TimeInterval

    var formattedPlayCount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: playCount)) ?? "\(playCount)"
    }
}
