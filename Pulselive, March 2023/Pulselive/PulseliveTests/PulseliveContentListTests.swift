//
//  PulseliveContentListTests.swift
//  PulseliveTests
//
//  Created by Robin Macharg on 29/03/2023.
//

import XCTest
import Resolver
@testable import Pulselive

final class PulseliveContentListTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testContentList() async throws {
        Resolver.register { MockAPIService.shared }.implements(APIServiceProviding.self)
        MockAPIService.fail = .jsonDecodingError(structName: "JSON decoding error", details: "details")
        let sut = ContentListScreenViewModel() // sut = System Under Test
        await sut.loadArticles()
        XCTAssertEqual(sut.uiState, .error(message: "API Decoding Error: PLContentList -  \"details\""))
    }
}
