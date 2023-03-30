//
//  DateFormatter+Pulselive.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import Foundation

extension DateFormatter {

    /**
     * Parse the specific Pulselive date format
     * See e.g. https://useyourloaf.com/blog/swift-codable-with-custom-dates/
     */
    static let pulseLiveFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Could come from the device
        formatter.locale = Locale(identifier: "en_GB") // Could come from the device
        return formatter
    }()
}
