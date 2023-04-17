//
//  DateFormatter+Floww.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation

extension DateFormatter {

    private static func configureFormatter(formatter: DateFormatter) {
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Could come from the device
        formatter.locale = Locale(identifier: "en_US_POSIX") // Could come from the device
    }

    /**
     * Parse the specific CoinGecko date format
     * See e.g. https://useyourloaf.com/blog/swift-codable-with-custom-dates/
     */
    static let coinGeckoFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // e.g. 2021-11-10T14:24:19.604Z
        configureFormatter(formatter: formatter)
        return formatter
    }()

    /**
     * Formatters for chart x-axis
     */

    static let axisFormatter6M1Y: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MMM"
        configureFormatter(formatter: formatter)
        return formatter
    }()

    static let axisFormatter2Y: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "MMM yy"
        configureFormatter(formatter: formatter)
        return formatter
    }()

    static let axisFormatter4YAll: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy"
        configureFormatter(formatter: formatter)
        return formatter
    }()

    static let priceChartInfoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat =  "dd MMM yyyy"
        configureFormatter(formatter: formatter)
        return formatter
    }()
}
