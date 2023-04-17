//
//  MarketListScreenViewModelTests.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 12/04/2023.
//

import XCTest
@testable import FlowwExercise

final class MarketListScreenViewModelTests: XCTestCase {

    func test_loadEmptyMarkets() async throws {
        let sut = MarketListScreenViewModel(apiService: MockAPIService(markets: []))
        await sut.loadMarkets()
        XCTAssertEqual(sut.markets.count, 0)
    }

    func test_loadMarkets() async throws {
        // Inject a mock APIService provider, prepopulated with canned data
        let apiService = MockAPIService(markets: [
            CGMarket.mockMarketBTC,
            CGMarket.mockMarketETH])
        let sut = MarketListScreenViewModel(apiService: apiService)
        await sut.loadMarkets()

        XCTAssertEqual(sut.markets.count, 2)
        // Test order is preserved
        XCTAssertEqual(sut.markets[0].id, "bitcoin")
        XCTAssertEqual(sut.markets[1].id, "ethereum")
    }
}
