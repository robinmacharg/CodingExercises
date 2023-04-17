//
//  APIService+Requests.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import Foundation

/**
 * Individual endpoint requests
 */
extension APIService: APIServiceProviding {
    func getMarkets(
        vsCurrency: String,
        order: String,
        perPage: Int) async throws -> CGMarkets
    {
        let url = String(format: Endpoints.markets, vsCurrency, order, String(perPage))
        return try await makeAsyncRequest(
            url,
            returnType: CGMarkets.self,
            debug: DebugRequests.markets)
    }

    func getMarketChartData(marketID: String, period: String) async throws -> CGMarketData {
        let url = String(format: Endpoints.marketChart, String(marketID), period)
        return try await makeAsyncRequest(
            url,
            returnType: CGMarketData.self,
            debug: DebugRequests.marketChart)
    }
}
