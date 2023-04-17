//
//  PriceFormatterTests.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 13/04/2023.
//

import XCTest
@testable import FlowwExercise

final class PriceFormatterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /**
     * Test that the market cap formatting works as expected
     */
    func test_formatMarketCap() {

        // Small numbers and millions
        XCTAssertEqual(Double(0).toAbbreviatedString(), "$0.00")
        XCTAssertEqual(Double(1000).toAbbreviatedString(), "$1000.00")
        XCTAssertEqual(Double(10_000).toAbbreviatedString(), "$10000.00")
        XCTAssertEqual(Double(100_000).toAbbreviatedString(), "$100.0K")
        XCTAssertEqual(Double(1_000_000).toAbbreviatedString(), "$1.0M")
        XCTAssertEqual(Double(1_001_000).toAbbreviatedString(), "$1.0M")
        XCTAssertEqual(Double(1_010_000).toAbbreviatedString(), "$1.0M")
        XCTAssertEqual(Double(1_100_000).toAbbreviatedString(), "$1.1M")
        XCTAssertEqual(Double(1_500_000).toAbbreviatedString(), "$1.5M")

        // Billions
        XCTAssertEqual(Double(1_000_000_000).toAbbreviatedString(), "$1.0B")
        XCTAssertEqual(Double(1_000_100_000).toAbbreviatedString(), "$1.0B")
        XCTAssertEqual(Double(1_100_000_000).toAbbreviatedString(), "$1.1B")
        XCTAssertEqual(Double(1_555_000_000).toAbbreviatedString(), "$1.6B")
        XCTAssertEqual(Double(123_100_000_000).toAbbreviatedString(), "$123.1B")
    }
}
