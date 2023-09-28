//
//  TestAccountsViewModel.swift
//  MoneyBoxTests
//
//  Created by Robin Macharg on 27/09/2023.
//

import XCTest
import Combine
@testable import MoneyBox
@testable import Networking

final class TestAccountsViewModel: XCTestCase {
    
    private var bindings = Set<AnyCancellable>()
    
    func testValidAccounts() {
        let sut = AccountsViewModel(dataProvider: DataProviderMock(succeed: true))
        let expectation = XCTestExpectation(description: "Login successfully")
        var expectedStates: [AccountsViewModel.State] = [.initial, .loading, .loaded]
        
        sut.$state
            .sink { state in
                XCTAssertEqual(state, expectedStates.first)
                expectedStates.remove(at: 0)
                if expectedStates.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &bindings)
        
        sut.loadData()
        wait(for: [expectation], timeout: 5)
    }
    
    func testAccountsFailToLoad() throws {
        let sut = AccountsViewModel(dataProvider: DataProviderMock(succeed: false))
        let expectation = XCTestExpectation(description: "Login successfully")
        // All AccountsResponse values are optional, so we will always end up in a .loaded state
        // This points to a tweak needed in ingestion to highlight that the response
        // was unexpected.  Should we treat nil as an error (and [] as success?)
        // Left in as a point for discussion.
        var expectedStates: [AccountsViewModel.State] = [.initial, .loading, .loaded]
        
        sut.$state
            .sink { state in
                XCTAssertEqual(state, expectedStates.first)
                expectedStates.remove(at: 0)
                if expectedStates.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &bindings)
        
        sut.loadData()
        wait(for: [expectation], timeout: 5)
        let productResponses = try XCTUnwrap(sut.productResponses)
        XCTAssertTrue(productResponses.isEmpty)
    }
}
