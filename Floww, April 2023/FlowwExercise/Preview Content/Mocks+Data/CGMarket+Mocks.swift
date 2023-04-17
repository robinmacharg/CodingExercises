//
//  CGMarket+Mocks.swift
//  FlowwExerciseTests
//
//  Created by Robin Macharg on 13/04/2023.
//

import Foundation

#if DEBUG
/**
 * Provide mock market data
 */
extension CGMarket: BundleFileLoading {
    static var mockMarketBTC = getBundleFile("market_btc.json", as: CGMarket.self)
    static var mockMarketETH = getBundleFile("market_eth.json", as: CGMarket.self)
}
#endif
