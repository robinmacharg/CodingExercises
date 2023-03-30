//
//  APIService+Endpoints.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import Foundation

extension APIService {

    /**
     * API endpoints used by the app.  We could further abstract domains etc for testing/dev via e.g. XCConfig
     */
    enum Endpoints {
        /// The list of articles
        static let contentList = "https://dynamic.pulselive.com/test/native/contentList.json"

        /// The endpoint for a specific article.  Note the use of a template placeholder ('%@')
        static let contentDetail = "https://dynamic.pulselive.com/test/native/content/%@.json"
    }
}
