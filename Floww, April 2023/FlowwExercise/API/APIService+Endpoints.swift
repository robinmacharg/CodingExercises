//
//  APIService+Endpoints.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import Foundation

extension APIService {

    static let apiRoot = "https://api.coingecko.com/api/v3"

    /**
     * API endpoints used by the app.  We could further abstract domains etc for testing/dev via e.g. XCConfig
     */
    enum Endpoints {
        /// The list of markets
        static let markets = "\(apiRoot)/coins/markets?vs_currency=%@&order=%@&per_page=%@"

        /// Market chart data.  Note the use of a template placeholder ('%@')
        static let marketChart = "\(apiRoot)/coins/%@/market_chart?vs_currency=usd&days=%@&Interval=daily"
    }
}
