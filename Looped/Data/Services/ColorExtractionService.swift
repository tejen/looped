//
//  ColorExtractionService.swift
//  Looped
//

import SwiftUI
import UIKit
import CoreImage

actor ColorExtractionService {
    static let shared = ColorExtractionService()

    private var cache: [URL: [Color]] = [:]

    private init() {}

    func extractColors(from url: URL, count: Int = 3) async -> [Color] {
        if let cached = cache[url] {
            return cached
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else {
                return defaultColors
            }

            let colors = await extractDominantColors(from: uiImage, count: count)
            cache[url] = colors
            return colors
        } catch {
            return defaultColors
        }
    }

    func extractColors(from image: UIImage, count: Int = 3) async -> [Color] {
        await extractDominantColors(from: image, count: count)
    }

    private func extractDominantColors(from image: UIImage, count: Int) async -> [Color] {
        guard let cgImage = image.cgImage else { return defaultColors }

        let width = 50
        let height = 50

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return defaultColors }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let data = context.data else { return defaultColors }

        let pointer = data.bindMemory(to: UInt8.self, capacity: width * height * 4)
        var colorCounts: [UInt32: Int] = [:]

        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * 4
                let r = pointer[offset]
                let g = pointer[offset + 1]
                let b = pointer[offset + 2]

                // Quantize to reduce unique colors
                let qr = (r / 32) * 32
                let qg = (g / 32) * 32
                let qb = (b / 32) * 32

                let colorKey = UInt32(qr) << 16 | UInt32(qg) << 8 | UInt32(qb)
                colorCounts[colorKey, default: 0] += 1
            }
        }

        let sortedColors = colorCounts.sorted { $0.value > $1.value }
        var result: [Color] = []

        for (colorKey, _) in sortedColors.prefix(count * 2) {
            let r = Double((colorKey >> 16) & 0xFF) / 255.0
            let g = Double((colorKey >> 8) & 0xFF) / 255.0
            let b = Double(colorKey & 0xFF) / 255.0

            let color = Color(red: r, green: g, blue: b)

            // Skip colors that are too dark or too light
            let brightness = (r + g + b) / 3
            if brightness > 0.1 && brightness < 0.9 {
                result.append(color)
            }

            if result.count >= count {
                break
            }
        }

        // Ensure we have enough colors
        while result.count < count {
            result.append(defaultColors[result.count % defaultColors.count])
        }

        return result
    }

    private var defaultColors: [Color] {
        [
            Color(red: 0.4, green: 0.2, blue: 0.8),
            Color(red: 0.8, green: 0.3, blue: 0.5),
            Color(red: 0.2, green: 0.5, blue: 0.8)
        ]
    }

    func clearCache() {
        cache.removeAll()
    }
}
