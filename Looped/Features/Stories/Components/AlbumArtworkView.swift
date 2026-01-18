//
//  AlbumArtworkView.swift
//  Looped
//

import SwiftUI

struct AlbumArtworkView: View {
    let url: URL?
    let size: CGFloat
    let cornerRadius: CGFloat
    let showShadow: Bool
    let glowColor: Color?

    init(
        url: URL?,
        size: CGFloat = 200,
        cornerRadius: CGFloat = 16,
        showShadow: Bool = true,
        glowColor: Color? = nil
    ) {
        self.url = url
        self.size = size
        self.cornerRadius = cornerRadius
        self.showShadow = showShadow
        self.glowColor = glowColor
    }

    var body: some View {
        Group {
            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderView
                    case .empty:
                        placeholderView
                            .overlay(
                                ProgressView()
                                    .tint(.white)
                            )
                    @unknown default:
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(
            color: showShadow ? (glowColor ?? .black).opacity(0.4) : .clear,
            radius: showShadow ? 20 : 0,
            y: showShadow ? 10 : 0
        )
        .if(glowColor != nil) { view in
            view.glowEffect(color: glowColor!, radius: 30)
        }
    }

    private var placeholderView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(white: 0.2),
                    Color(white: 0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "music.note")
                .font(.system(size: size * 0.3))
                .foregroundStyle(Color.white.opacity(0.3))
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct LargeArtworkView: View {
    let url: URL?
    let artistName: String
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 24) {
            AlbumArtworkView(
                url: url,
                size: 280,
                cornerRadius: 24,
                showShadow: true
            )
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)

            Text(artistName)
                .font(Typography.heroSubtitle)
                .foregroundStyle(LoopedTheme.primaryText)
                .multilineTextAlignment(.center)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
        }
        .onAppear {
            withAnimation(LoopedTheme.defaultAnimation.delay(0.2)) {
                isVisible = true
            }
        }
    }
}

struct MiniArtworkRow: View {
    let songs: [SongStats]

    var body: some View {
        HStack(spacing: -20) {
            ForEach(Array(songs.prefix(5).enumerated()), id: \.element.id) { index, song in
                AlbumArtworkView(
                    url: song.artworkURL,
                    size: 60,
                    cornerRadius: 8,
                    showShadow: false
                )
                .zIndex(Double(5 - index))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VStack {
            AlbumArtworkView(url: nil, size: 200)
            LargeArtworkView(url: nil, artistName: "Taylor Swift")
        }
    }
}
