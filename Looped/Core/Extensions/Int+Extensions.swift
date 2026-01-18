//
//  Int+Extensions.swift
//  Looped
//

import SwiftUI

extension Int {
    /// Returns the integer as a string without formatting (no commas)
    /// Useful for years: 2025 instead of 2,025
    var unformatted: String {
        String(self)
    }
}
