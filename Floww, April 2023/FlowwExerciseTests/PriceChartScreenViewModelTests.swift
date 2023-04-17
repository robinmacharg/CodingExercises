//
//  PriceChartScreenViewModelTests.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 13/04/2023.
//

import XCTest
@testable import FlowwExercise

final class PriceChartScreenViewModelTests: XCTestCase {
    func test_loadData() async throws {
        let sut = PriceChartScreenViewModel(
            marketID: "bitcoin",
            apiService: MockAPIService(prices: CGMarketData.mockMarketPricesBTC))
        await sut.loadPrices()
        XCTAssertEqual(sut.prices.count, 366)
    }
}
