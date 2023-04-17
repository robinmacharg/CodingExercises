//
//  CGMarketPrices+Mocks.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation

#if DEBUG

/**
 * Provide mock price data
 */
extension CGMarketData: BundleFileLoading {
    static var mockMarketPricesBTC = getBundleFile("prices_btc.json", as: CGMarketData.self)
}

#endif
