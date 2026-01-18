//
//  MusicKitService.swift
//  Looped
//

import Foundation
import MusicKit

actor MusicKitService {
    static let shared = MusicKitService()

    private let player = ApplicationMusicPlayer.shared

    private init() {}

    enum AuthorizationError: Error {
        case denied
        case restricted
        case unknown
    }

    func requestAuthorization() async throws -> Bool {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            return true
        case .denied:
            throw AuthorizationError.denied
        case .restricted:
            throw AuthorizationError.restricted
        case .notDetermined:
            throw AuthorizationError.unknown
        @unknown default:
            throw AuthorizationError.unknown
        }
    }

    func checkAuthorizationStatus() -> MusicAuthorization.Status {
        MusicAuthorization.currentStatus
    }

    func fetchRecentlyPlayed() async throws -> [RecentlyPlayedMusicItem] {
        var request = MusicRecentlyPlayedRequest<Song>()
        request.limit = 25
        let response = try await request.response()

        return response.items.map { song in
            RecentlyPlayedMusicItem(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                albumTitle: song.albumTitle ?? "",
                artworkURL: song.artwork?.url(width: 600, height: 600),
                duration: song.duration ?? 0,
                genreNames: song.genreNames,
                playDate: Date()
            )
        }
    }

    func fetchLibrarySongs() async throws -> [LibrarySongItem] {
        var request = MusicLibraryRequest<Song>()
        request.limit = 500
        let response = try await request.response()

        var items: [LibrarySongItem] = []

        for song in response.items {
            // Load genres relationship for each song
            var genreNames = song.genreNames
            if genreNames.isEmpty {
                // Try to load genres from the full song data
                if let songWithGenres = try? await song.with([.genres]) {
                    genreNames = songWithGenres.genres?.map { $0.name } ?? []
                }
            }

            items.append(LibrarySongItem(
                id: song.id.rawValue,
                title: song.title,
                artistName: song.artistName,
                albumTitle: song.albumTitle ?? "",
                artworkURL: song.artwork?.url(width: 600, height: 600),
                duration: song.duration ?? 0,
                genreNames: genreNames,
                playCount: song.playCount ?? 0,
                lastPlayedDate: song.lastPlayedDate
            ))
        }

        return items
    }

    func fetchArtworkURL(for song: Song, size: Int = 600) -> URL? {
        song.artwork?.url(width: size, height: size)
    }

    // MARK: - Playback

    enum PlaybackError: Error {
        case songNotFound
        case playbackFailed
    }

    func playSong(id: String) async throws {
        // Use library request since songs come from user's library
        var request = MusicLibraryRequest<Song>()
        request.filter(matching: \.id, equalTo: MusicItemID(id))
        let response = try await request.response()

        guard let song = response.items.first else {
            throw PlaybackError.songNotFound
        }

        player.queue = [song]
        try await player.play()
    }

    func pausePlayback() {
        player.pause()
    }

    func stopPlayback() {
        player.stop()
    }

    var isPlaying: Bool {
        player.state.playbackStatus == .playing
    }
}

struct RecentlyPlayedMusicItem: Identifiable, Sendable {
    let id: String
    let title: String
    let artistName: String
    let albumTitle: String
    let artworkURL: URL?
    let duration: TimeInterval
    let genreNames: [String]
    let playDate: Date
}

struct LibrarySongItem: Identifiable, Sendable {
    let id: String
    let title: String
    let artistName: String
    let albumTitle: String
    let artworkURL: URL?
    let duration: TimeInterval
    let genreNames: [String]
    let playCount: Int
    let lastPlayedDate: Date?
}
