//
//  CGMarketData.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//
// This file was generated from JSON Schema using quicktype

import Foundation

// MARK: - CGMarketData
struct CGMarketData: Codable {
    let prices: [[Double]]
    let marketCaps: [[Double?]]?
    let totalVolumes: [[Double]]

    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
}
