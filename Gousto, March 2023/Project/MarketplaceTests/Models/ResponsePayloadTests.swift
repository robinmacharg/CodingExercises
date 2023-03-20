import XCTest
@testable import Marketplace

// MARK: - ResponsePayload Tests

class ResponsePayloadTests: XCTestCase {

    func testSuccessfulDecode() throws {

        let data = """
        {
          "status": "ok",
          "data": ["A", "B", "C"]
        }
        """.data(using: .utf8)

        let payload = try JSONDecoder().decode(ResponsePayload<[String]>.self, from: XCTUnwrap(data))

        XCTAssertEqual(payload.status, "ok")
        XCTAssertEqual(payload.data, ["A", "B", "C"])
    }
}
