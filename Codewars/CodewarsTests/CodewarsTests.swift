//
//  CodewarsTests.swift
//  CodewarsTests
//
//  Created by Robin Macharg on 16/03/2022.
//

import XCTest
@testable import Codewars

class SolutionTest: XCTestCase {

    func testFindTheOddInt() throws {
        let testCases = [
            ([20,1,-1,2,-2,3,3,5,5,1,2,4,20,4,-1,-2,5], 5),
            ([1,1,2,-2,5,2,4,4,-1,-2,5], -1),
            ([20,1,1,2,2,3,3,5,5,4,20,4,5], 5),
            ([10], 10),
            ([1,1,1,1,1,1,10,1,1,1,1], 10),
        ]
        for testCase in testCases {
            let actual = Codewars.findTheOddInt(testCase.0);
            let expected = testCase.1;
            XCTAssertEqual(actual, expected, "\nInvalid answer for input array: \(testCase.0)\nExpected: \(expected)\nActual: \(actual)")
        }
    }

    func testRowSumOddNumbers() throws {
        XCTAssertEqual(rowSumOddNumbers(1), 1)
        XCTAssertEqual(rowSumOddNumbers(2), 8)
        XCTAssertEqual(rowSumOddNumbers(3), 35)
        XCTAssertEqual(rowSumOddNumbers(4), 35)
        XCTAssertEqual(rowSumOddNumbers(5), 35)
//        XCTAssertEqual(rowSumOddNumbers(13), 2197)
//        XCTAssertEqual(rowSumOddNumbers(19), 6859)
//        XCTAssertEqual(rowSumOddNumbers(41), 68921)
//        XCTAssertEqual(rowSumOddNumbers(42), 74088)
//        XCTAssertEqual(rowSumOddNumbers(74), 405224)
//        XCTAssertEqual(rowSumOddNumbers(86), 636056)
//        XCTAssertEqual(rowSumOddNumbers(93), 804357)
//        XCTAssertEqual(rowSumOddNumbers(101), 1030301)
    }
}

