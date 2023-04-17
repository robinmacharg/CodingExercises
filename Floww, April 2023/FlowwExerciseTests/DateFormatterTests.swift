//
//  DateFormatterTests.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 13/04/2023.
//

import XCTest
@testable import FlowwExercise

final class DateFormatterTests: XCTestCase {
    func testDateFormatter() throws {
        let dateFormatter = DateFormatter.coinGeckoFormat
        if let date = dateFormatter.date(from: "2021-11-10T14:24:19.604Z") {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            XCTAssertEqual(components.year, 2021)
            XCTAssertEqual(components.month, 11)
            XCTAssertEqual(components.day, 10)
            XCTAssertEqual(components.hour, 14)
            XCTAssertEqual(components.minute, 24)
        }
        else {
            XCTFail("Failed to parse date")
        }
    }
}
