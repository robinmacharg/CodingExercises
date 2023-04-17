//
//  MockAPIService.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation

final class MockAPIService: APIServiceProviding {
    var markets: CGMarkets = []
    var prices: CGMarketData = CGMarketData(
        prices: [],
        marketCaps: [],
        totalVolumes: [])

    init(markets: CGMarkets = []) {
        self.markets = markets
    }

    init(prices: CGMarketData = CGMarketData(
        prices: [],
        marketCaps: [],
        totalVolumes: [])) {
        self.prices = prices
    }

    func getMarkets(vsCurrency: String, order: String, perPage: Int) async throws -> CGMarkets {
        return self.markets
    }

    func getMarketChartData(marketID: String, period: String) async throws -> CGMarketData {
        return self.prices
    }
}
