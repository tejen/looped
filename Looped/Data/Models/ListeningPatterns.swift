//
//  ListeningPatterns.swift
//  Looped
//

import Foundation

struct ListeningPatterns: Sendable {
    let hourlyDistribution: [Int: Int]  // Hour (0-23) -> play count
    let weekdayDistribution: [Int: Int] // Weekday (1-7, Sunday=1) -> play count

    var peakHour: Int {
        hourlyDistribution.max(by: { $0.value < $1.value })?.key ?? 12
    }

    var peakWeekday: Int {
        weekdayDistribution.max(by: { $0.value < $1.value })?.key ?? 1
    }

    var peakTimeDescription: String {
        switch peakHour {
        case 5..<9:
            return "Early Bird"
        case 9..<12:
            return "Morning Groover"
        case 12..<14:
            return "Lunch Break DJ"
        case 14..<17:
            return "Afternoon Vibes"
        case 17..<20:
            return "Evening Listener"
        case 20..<24:
            return "Night Owl"
        default:
            return "Midnight Explorer"
        }
    }

    var peakWeekdayName: String {
        let formatter = DateFormatter()
        formatter.weekdaySymbols = formatter.weekdaySymbols
        guard peakWeekday >= 1 && peakWeekday <= 7 else { return "Unknown" }
        return formatter.weekdaySymbols[peakWeekday - 1]
    }

    var formattedPeakHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        var components = DateComponents()
        components.hour = peakHour
        guard let date = Calendar.current.date(from: components) else { return "\(peakHour):00" }
        return formatter.string(from: date)
    }
}
