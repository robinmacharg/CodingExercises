//
//  Double+Floww.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation

extension Double {

    /**
     * Convert a double into an abbreviated form with a unit suffix.
     * e.g. 1100000 -> "$1.1M".  Note the hardcoded dollar currency.
     */
    func toAbbreviatedString() -> String {
        switch self {
        case 0..<10_000:
            return String(format: "$%.2f", self)
        case 10_000..<1_000_000:
            return String(format: "$%.1fK", self / 1_000)
        case 1_000_000..<1_000_000_000:
            return String(format: "$%.1fM", self / 1_000_000)
        default:
            return String(format: "$%.1fB", self / 1_000_000_000)
        }
    }
}
