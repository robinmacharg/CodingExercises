//
//  PulseliveAPITests.swift
//  PulseliveAPITests
//
//  Created by Robin Macharg on 28/03/2023.
//

import XCTest
import Resolver
@testable import Pulselive

/**
 * Test the API functionality
 */
final class PulseliveAPITests: XCTestCase {

    override func setUpWithError() throws {
        MockAPIService.fail = nil
    }
    override func tearDownWithError() throws {}

    func testContentList() async throws {
        Resolver.register { MockAPIService.shared }.implements(APIServiceProviding.self)
        let api = Resolver.resolve(APIServiceProviding.self)

        do {
            let content = try await api.getContentList()
            XCTAssertEqual(content.items.count, 4) // hardcoded
            XCTAssertEqual(content.items[0].title, "article1")
            // etc...
        } catch let error {
            XCTFail("ContentList retrieval failure: \(error.localizedDescription)")
        }
    }

    func testContentDetail() async throws {
        Resolver.register { MockAPIService.shared }.implements(APIServiceProviding.self)
        let api = Resolver.resolve(APIServiceProviding.self)

        do {
            // This is one place where dependency injection would help
            let detail = try await api.getContentDetails(articleID: 29).item
            XCTAssertEqual(detail.id, 1)
            XCTAssertEqual(detail.subtitle, "article1 subtitle")
            XCTAssertEqual(detail.body, "lorem ipsum foo")
            // etc...
        } catch let error {
            XCTFail("ContentDetail retrieval failure: \(error.localizedDescription)")
        }
    }
}
