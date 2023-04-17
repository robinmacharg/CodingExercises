//
//  XAxisMarkFormattingTests.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 14/04/2023.
//

import XCTest
import Charts
@testable import FlowwExercise

final class XAxisMarkFormattingTests: XCTestCase {
    func testXAxisMarkFormatting1() throws {
        let timestamp: Double = 1367280000
        let date = Date(timeIntervalSince1970: timestamp)

        let sut = PriceChartScreenViewModel(
            marketID: "bitcoin",
            apiService: MockAPIService(prices: CGMarketData.mockMarketPricesBTC))

        sut.chartPeriod = ._6m
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "Apr")

        sut.chartPeriod = ._1y
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "Apr")

        sut.chartPeriod = ._2y
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "Apr 13")

        sut.chartPeriod = ._4y
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "2013")

        sut.chartPeriod = .all
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "2013")
    }

    func testXAxisMarkFormatting2() throws {
        let timestamp: Double = 1622332800
        let date = Date(timeIntervalSince1970: timestamp)

        let sut = PriceChartScreenViewModel(
            marketID: "bitcoin",
            apiService: MockAPIService(prices: CGMarketData.mockMarketPricesBTC))

        sut.chartPeriod = ._6m
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "May")

        sut.chartPeriod = ._1y
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "May")

        sut.chartPeriod = ._2y
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "May 21")

        sut.chartPeriod = ._4y
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "2021")

        sut.chartPeriod = .all
        XCTAssertEqual(sut.xAxisLabel(timestamp: date), "2021")
    }
}
