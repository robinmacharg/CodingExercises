//
//  APIService+Debugging.swift
//  FlowwExercise
//
//  Created by Robin Macharg on 12/04/2023.
//

import Foundation

extension APIService {

    /**
     * Defines which requests should produce debug (e.g. cURL request + response) output
     * Enabled for illustration
     */
    enum DebugRequests {
        static let all = false // overrides all the below
        static let cURL = true // cURL output
        static let markets = false
        static let marketChart = false
    }
}
