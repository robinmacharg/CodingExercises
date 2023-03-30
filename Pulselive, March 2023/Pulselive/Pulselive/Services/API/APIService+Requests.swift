//
//  APIService+Requests.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//

import Foundation

/**
 * Individual endpoint requests
 */
extension APIService: APIServiceProviding {
    func getContentList() async throws -> PLContentList {
        return try await makeAsyncRequest(
            Endpoints.contentList,
            returnType: PLContentList.self,
            debug: DebugRequests.contentList)
    }

    func getContentDetails(articleID: Int) async throws -> PLContentDetail {
        let url = String(format: Endpoints.contentDetail, String(articleID))
        return try await makeAsyncRequest(
            url,
            returnType: PLContentDetail.self,
            debug: DebugRequests.contentDetail)
    }
}
