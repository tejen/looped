//
//  StatsCalculationEngine.swift
//  Looped
//

import Foundation

actor StatsCalculationEngine {
    static let shared = StatsCalculationEngine()

    private init() {}

    func calculateStats(from songs: [LibrarySongItem], year: Int = 2025) async -> ListeningStats {
        let playedSongs = songs.filter { $0.playCount > 0 }

        let topSongs = calculateTopSongs(from: playedSongs)
        let topArtists = calculateTopArtists(from: playedSongs)
        let topGenres = calculateTopGenres(from: playedSongs)
        let patterns = calculateListeningPatterns(from: playedSongs)
        let aura = AudioAura.generate(from: topGenres)

        let totalMinutes = playedSongs.reduce(0) { total, song in
            total + Int(song.duration * Double(song.playCount) / 60)
        }

        let totalPlays = playedSongs.reduce(0) { $0 + $1.playCount }
        let uniqueArtists = Set(playedSongs.map { $0.artistName }).count

        return ListeningStats(
            year: year,
            totalMinutesListened: totalMinutes,
            totalSongsPlayed: totalPlays,
            totalArtistsDiscovered: uniqueArtists,
            topArtists: topArtists,
            topSongs: topSongs,
            topGenres: topGenres,
            listeningPatterns: patterns,
            audioAura: aura
        )
    }

    private func calculateTopSongs(from songs: [LibrarySongItem], limit: Int = 5) -> [SongStats] {
        let sorted = songs.sorted { $0.playCount > $1.playCount }
        return Array(sorted.prefix(limit)).map { song in
            SongStats(
                id: song.id,
                title: song.title,
                artistName: song.artistName,
                albumTitle: song.albumTitle,
                artworkURL: song.artworkURL,
                playCount: song.playCount,
                totalPlayTime: song.duration * Double(song.playCount)
            )
        }
    }

    private func calculateTopArtists(from songs: [LibrarySongItem], limit: Int = 5) -> [ArtistStats] {
        var artistData: [String: (playCount: Int, playTime: TimeInterval, topSong: String?, genres: Set<String>, artworkURL: URL?)] = [:]

        for song in songs {
            let existing = artistData[song.artistName] ?? (0, 0, nil, [], nil)
            let newPlayCount = existing.playCount + song.playCount
            let newPlayTime = existing.playTime + (song.duration * Double(song.playCount))
            let topSong = existing.playCount > song.playCount ? existing.topSong : song.title
            var genres = existing.genres
            song.genreNames.forEach { genres.insert($0) }
            let artwork = existing.artworkURL ?? song.artworkURL

            artistData[song.artistName] = (newPlayCount, newPlayTime, topSong, genres, artwork)
        }

        let sorted = artistData.sorted { $0.value.playCount > $1.value.playCount }
        return Array(sorted.prefix(limit)).enumerated().map { index, item in
            ArtistStats(
                id: "\(index)",
                name: item.key,
                artworkURL: item.value.artworkURL,
                playCount: item.value.playCount,
                totalPlayTime: item.value.playTime,
                topSongTitle: item.value.topSong,
                genres: Array(item.value.genres)
            )
        }
    }

    private func calculateTopGenres(from songs: [LibrarySongItem], limit: Int = 5) -> [GenreStats] {
        var genreCounts: [String: Int] = [:]
        var totalPlays = 0

        for song in songs {
            for genre in song.genreNames {
                genreCounts[genre, default: 0] += song.playCount
                totalPlays += song.playCount
            }
        }

        // Normalize - each song only counts once for total
        totalPlays = songs.reduce(0) { $0 + $1.playCount }

        let sorted = genreCounts.sorted { $0.value > $1.value }
        return Array(sorted.prefix(limit)).enumerated().map { index, item in
            let percentage = totalPlays > 0 ? (Double(item.value) / Double(totalPlays)) * 100 : 0
            return GenreStats(
                id: "\(index)",
                name: item.key,
                playCount: item.value,
                percentage: min(percentage, 100)
            )
        }
    }

    private func calculateListeningPatterns(from songs: [LibrarySongItem]) -> ListeningPatterns {
        var hourly: [Int: Int] = [:]
        var weekday: [Int: Int] = [:]

        // Initialize with some distribution based on play counts
        // Since we don't have exact play times, we'll simulate patterns
        for song in songs where song.lastPlayedDate != nil {
            if let date = song.lastPlayedDate {
                let hour = Calendar.current.component(.hour, from: date)
                let day = Calendar.current.component(.weekday, from: date)
                hourly[hour, default: 0] += song.playCount
                weekday[day, default: 0] += song.playCount
            }
        }

        // If no data, create sample distribution
        if hourly.isEmpty {
            hourly = [
                8: 120, 9: 180, 10: 150, 11: 130,
                12: 200, 13: 220, 14: 190, 15: 160,
                16: 180, 17: 250, 18: 320, 19: 380,
                20: 420, 21: 450, 22: 380, 23: 280,
                0: 150, 1: 80
            ]
        }

        if weekday.isEmpty {
            weekday = [1: 1200, 2: 980, 3: 1050, 4: 1100, 5: 1150, 6: 1400, 7: 1350]
        }

        return ListeningPatterns(hourlyDistribution: hourly, weekdayDistribution: weekday)
    }
}
