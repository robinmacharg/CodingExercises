//
//  APIService+Debugging.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
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
        static let contentList = true
        static let contentDetail = true
    }
}
