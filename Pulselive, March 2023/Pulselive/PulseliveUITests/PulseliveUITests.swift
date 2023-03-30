//
//  PulseliveUITests.swift
//  PulseliveUITests
//
//  Created by Robin Macharg on 28/03/2023.
//

import XCTest

final class PulseliveUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testApp() throws {
        let app = XCUIApplication()
        app.launch()

        // Hardcoded
        let firstArticle = app.buttons["article29"]
        XCTAssert(firstArticle.waitForExistence(timeout: 5.0))
        firstArticle.tap()
        let subtitle = app.staticTexts["subtitle29"]
        XCTAssert(subtitle.waitForExistence(timeout: 5.0))
        XCTAssert(subtitle.label == "Article 1 subtitle with placeholder text")

        let body = app.staticTexts["body29"]
        XCTAssert(body.waitForExistence(timeout: 5.0))
        XCTAssert(body.label.starts(with: "Article 1 Lorem ipsum dolor sit amet"))
    }
}
