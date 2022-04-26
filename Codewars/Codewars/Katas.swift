//
//  Katas.swift
//  Codewars
//
//  Created by Robin Macharg on 16/03/2022.
//

import Foundation

/**
 Given an array of integers, find the one that appears an odd number of times.

 There will always be only one integer that appears an odd number of times.

 Examples
 [7] should return 7, because it occurs 1 time (which is odd).
 [0] should return 0, because it occurs 1 time (which is odd).
 [1,1,2] should return 2, because it occurs 1 time (which is odd).
 [0,1,0,1,0] should return 0, because it occurs 3 times (which is odd).
 [1,2,2,3,3,3,4,3,3,3,2,2,1] should return 4, because it appears 1 time (which is odd).
 */
func findTheOddInt(_ seq: [Int]) -> Int {
    return Dictionary(grouping: seq, by: { $0 } )
        .filter { $0.value.count % 2 == 1 }
        .map { $0.key }[0]
}

/**
 Given the triangle of consecutive odd numbers:

 1
 3     5
 7     9    11
 13    15    17    19
 21    23    25    27    29
 ...
 Calculate the sum of the numbers in the nth row of this triangle (starting at index 1) e.g.: (Input --> Output)

 1 -->  1
 2 --> 3 + 5 = 8
 */
func rowSumOddNumbers(_ row: Int) -> Int {

    let start = pow(2, row) - 1
    let end = start + (Decimal(row) * 2) - 1

    print(start)

//    print(pow(2, row) - 1)
    for n in stride(from: start, through: end, by: 2) {//start..<end { //}.forEach { x in
        print(n)
    }
    return 0
}
