import XCTest

class MarketplaceUITests: XCTestCase {

    func testExample() throws {

        let app = XCUIApplication()
        app.launch()

        XCTAssertNotNil(app.images["Gousto logo"].firstMatch)
        XCTAssertNotNil(app.staticTexts["Welcome to the Gousto Marketplace!"].firstMatch)
        XCTAssertNotNil(app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "You can check out our marketplace products now")).firstMatch)
        let button = try XCTUnwrap(app.buttons["Open Marketplace"].firstMatch)
        XCTAssertTrue(button.isEnabled)
        XCTAssertTrue(button.isHittable)
    }
}
