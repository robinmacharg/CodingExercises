//
//  TestLoginViewModel.swift
//  MoneyBoxTests
//
//  Created by Robin Macharg on 27/09/2023.
//

import XCTest
import Combine
@testable import MoneyBox
@testable import Networking

final class TestLoginViewModel: XCTestCase {

    private var bindings = Set<AnyCancellable>()
    private let email = "test@moneybox.com"
    private let password = "password123"
    
    func testValidLogin() {
        // SUT == System Under Test
        let sut = LoginViewModel(dataProvider: DataProviderMock(succeed: true))
        sut.email = email
        sut.password = password
        
        let expectation = XCTestExpectation(description: "Login successfully")
        var expectedStates: [LoginViewModel.State] = [.validCredentials(true), .loggingIn, .loggedIn]
        
        sut.$state
            .sink { state in
                XCTAssertEqual(state, expectedStates.first)
                expectedStates.remove(at: 0)
                if state == .loggedIn {
                    expectation.fulfill()
                }
            }
            .store(in: &bindings)
        
        XCTAssertNil(Authentication.token)
        sut.login()
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(Authentication.token)
        XCTAssertTrue(expectedStates.isEmpty)
    }
    
    func testInvalidLoginNoEmailPassword() {
        let sut = LoginViewModel(dataProvider: DataProviderMock(succeed: true))
        sut.email = nil
        sut.password = nil
        
        let expectation = XCTestExpectation(description: "Login failed")
        var expectedStates: [LoginViewModel.State] = [.validCredentials(false), .error(.loginDetailNotProvided)]
        
        sut.$state
            .sink { state in
                XCTAssertEqual(state, expectedStates.first)
                expectedStates.remove(at: 0)
                if state == .error(.loginDetailNotProvided) {
                    expectation.fulfill()
                }
            }
            .store(in: &bindings)
        
        sut.login()
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(expectedStates.isEmpty)
    }
    
    func testInvalidLoginBadCredentials() {
        let sut = LoginViewModel(dataProvider: DataProviderMock(succeed: false))
        sut.email = email
        sut.password = password
        
        let expectation = XCTestExpectation(description: "Login failed")
        var expectedStates: [LoginViewModel.State] = [
            .validCredentials(true),
            .loggingIn,
            .error(.loginFailed("Login Failed.  Please try again."))]
        
        sut.$state
            .sink { state in
                XCTAssertTrue(state == expectedStates.first)
                expectedStates.remove(at: 0)
                if state == .error(.loginFailed("Login Failed.  Please try again.")) {
                    expectation.fulfill()
                }
            }
            .store(in: &bindings)
        
        sut.login()
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(expectedStates.isEmpty)
    }
}
