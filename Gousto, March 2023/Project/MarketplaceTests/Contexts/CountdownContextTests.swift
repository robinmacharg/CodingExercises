import XCTest
@testable import Marketplace

// MARK: - CountdownContext Tests

class CountdownContextTests: XCTestCase {

    func testInitialisation() {

        let countdown = Countdown(updateInterval: 20)

        XCTAssertEqual(countdown.updateInterval, 20)
    }

    func testUpdateCalledAfterStart() {

        let countdown = Countdown(updateInterval: 1)

        let expectation = expectation(description: "Update should be called")

        countdown.start(countdownTo: Date(timeIntervalSinceNow: 2)) { updatedInterval in

            expectation.fulfill()

            XCTAssertEqual(updatedInterval, "1 second remaining")
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}
