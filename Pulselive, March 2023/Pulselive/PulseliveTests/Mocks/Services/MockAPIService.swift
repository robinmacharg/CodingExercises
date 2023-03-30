//
//  MockAPIService.swift
//  PulseliveTests
//
//  Created by Robin Macharg on 29/03/2023.
//

import Foundation
@testable import Pulselive

#if DEBUG
final class MockAPIService: APIServiceProviding {

    static let shared: MockAPIService = .init()
    private init() {}

    /// Allows us to set the Mock to fail in specific ways
    static var fail: APIServiceError?

    func getContentList() async throws -> Pulselive.PLContentList {
        if let failure = MockAPIService.fail {
            switch failure {
            case .jsonDecodingError:
                throw APIServiceError.jsonDecodingError(structName: "PLContentList", details: "details")
            // etc...
            default:
                throw APIServiceError.unhandledError
            }
        }

        // Otherwise fall through
        return PLContentList(items: [
            PLContentListItem.item1,
            PLContentListItem.item2,
            PLContentListItem.item3,
            PLContentListItem.item4])
    }

    func getContentDetails(articleID: Int) async throws -> Pulselive.PLContentDetail {
        return PLContentDetail(item: PLContentDetailItem.detail1)
    }
}
#endif
