//
//  APIServiceProviding.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import Foundation

/**
 * Types providing API functionality should adopt this protocol
 */
protocol APIServiceProviding {
    func getMarkets(vsCurrency: String, order: String, perPage: Int) async throws -> CGMarkets
    func getMarketChartData(marketID: String, period: String) async throws -> CGMarketData
}
