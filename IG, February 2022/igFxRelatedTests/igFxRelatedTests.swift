//
//  igFxRelatedTests.swift
//  igFxRelatedTests
//
//  Created by Robin Macharg on 18/02/2022.
//

import XCTest
@testable import igFxRelated

class igFxRelatedTests: XCTestCase {
    
    // Used to test asynchronous functionality
    var expectation: XCTestExpectation!
    
    // MARK: - Testing Lifecycle
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        // Configure our API with a custom URLSession to intercept requests
        API.initialise(session: urlSession)
        expectation = expectation(description: "Expectation")
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Helpers
    
    /**
     * Load JSON data from the testing bundle
     */
    func loadLocalFileData(file: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file, ofType: "json")!
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    // MARK: - Tests
    
    func testMarketParsing() throws {
        guard let data = loadLocalFileData(file: "MarketParsingData"),
              let marketsURL = URL(string: API.endpoints.markets)
        else {
            throw IGFxError.generalError("Testing error")
        }
        
        // Set up our mocked handler with the correct response
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == marketsURL else {
                throw IGFxError.generalError("Testing error")
            }
            
            let response = HTTPURLResponse(
                url: marketsURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (response, data)
        }
        
        // Call the API
        API.shared.getMarkets { (result) in
            switch result {
            case .success(let markets):
                XCTAssertEqual(markets.currencies.count, 3, "Incorrect number of currencies.")
                XCTAssertEqual(markets.indices.count, 2, "Incorrect number of indices.")
                XCTAssertEqual(markets.commodities.count, 1, "Incorrect number of commodities.")
                // etc ...
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
