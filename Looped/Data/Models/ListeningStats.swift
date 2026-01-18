//
//  ListeningStats.swift
//  Looped
//

import Foundation

struct ListeningStats: Sendable {
    let year: Int
    let totalMinutesListened: Int
    let totalSongsPlayed: Int
    let totalArtistsDiscovered: Int
    let topArtists: [ArtistStats]
    let topSongs: [SongStats]
    let topGenres: [GenreStats]
    let listeningPatterns: ListeningPatterns
    let audioAura: AudioAura

    var formattedTotalTime: String {
        let hours = totalMinutesListened / 60
        let minutes = totalMinutesListened % 60
        if hours >= 24 {
            let days = hours / 24
            let remainingHours = hours % 24
            return "\(days) days, \(remainingHours) hours"
        }
        return "\(hours) hours, \(minutes) minutes"
    }

    var totalHours: Int {
        totalMinutesListened / 60
    }

    static var sample: ListeningStats {
        ListeningStats(
            year: 2025,
            totalMinutesListened: 42_680,
            totalSongsPlayed: 8_432,
            totalArtistsDiscovered: 247,
            topArtists: [
                ArtistStats(id: "1", name: "Taylor Swift", artworkURL: nil, playCount: 892, totalPlayTime: 48600, topSongTitle: "Anti-Hero", genres: ["Pop", "Country"]),
                ArtistStats(id: "2", name: "The Weeknd", artworkURL: nil, playCount: 654, totalPlayTime: 35400, topSongTitle: "Blinding Lights", genres: ["R&B", "Pop"]),
                ArtistStats(id: "3", name: "Drake", artworkURL: nil, playCount: 521, totalPlayTime: 28200, topSongTitle: "Rich Flex", genres: ["Hip-Hop", "R&B"]),
                ArtistStats(id: "4", name: "Dua Lipa", artworkURL: nil, playCount: 445, totalPlayTime: 24000, topSongTitle: "Levitating", genres: ["Pop", "Dance"]),
                ArtistStats(id: "5", name: "Bad Bunny", artworkURL: nil, playCount: 398, totalPlayTime: 21600, topSongTitle: "Me Porto Bonito", genres: ["Reggaeton", "Latin"]),
            ],
            topSongs: [
                SongStats(id: "1", title: "Anti-Hero", artistName: "Taylor Swift", albumTitle: "Midnights", artworkURL: nil, playCount: 247, totalPlayTime: 14820),
                SongStats(id: "2", title: "Blinding Lights", artistName: "The Weeknd", albumTitle: "After Hours", artworkURL: nil, playCount: 198, totalPlayTime: 11880),
                SongStats(id: "3", title: "As It Was", artistName: "Harry Styles", albumTitle: "Harry's House", artworkURL: nil, playCount: 176, totalPlayTime: 10560),
                SongStats(id: "4", title: "Levitating", artistName: "Dua Lipa", albumTitle: "Future Nostalgia", artworkURL: nil, playCount: 165, totalPlayTime: 9900),
                SongStats(id: "5", title: "Heat Waves", artistName: "Glass Animals", albumTitle: "Dreamland", artworkURL: nil, playCount: 143, totalPlayTime: 8580),
            ],
            topGenres: [
                GenreStats(id: "1", name: "Pop", playCount: 3200, percentage: 38),
                GenreStats(id: "2", name: "Hip-Hop", playCount: 1800, percentage: 21),
                GenreStats(id: "3", name: "R&B", playCount: 1400, percentage: 17),
                GenreStats(id: "4", name: "Rock", playCount: 1000, percentage: 12),
                GenreStats(id: "5", name: "Electronic", playCount: 600, percentage: 7),
            ],
            listeningPatterns: ListeningPatterns(
                hourlyDistribution: [
                    8: 120, 9: 180, 10: 150, 11: 130,
                    12: 200, 13: 220, 14: 190, 15: 160,
                    16: 180, 17: 250, 18: 320, 19: 380,
                    20: 420, 21: 450, 22: 380, 23: 280,
                    0: 150, 1: 80
                ],
                weekdayDistribution: [
                    1: 1200, 2: 980, 3: 1050, 4: 1100,
                    5: 1150, 6: 1400, 7: 1350
                ]
            ),
            audioAura: AudioAura(
                primaryMood: .uplifting,
                secondaryMood: .energetic,
                description: "Sunshine in audio form. Your music choices spread positivity and keep the good vibes flowing all year long."
            )
        )
    }
}
