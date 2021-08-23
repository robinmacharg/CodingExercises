//
//  ViewController.swift
//  ynab
//
//  Created by Robin Macharg2 on 24/03/2021.
//

import UIKit

class ViewController: UIViewController {

    private enum DataSetSize {
        case small
        case large(size: Int)
    }

    let simple = true

    override func viewDidLoad() {
        super.viewDidLoad()

        print("starting: \(Date())")
        callReconcileHelper(.small)
        callReconcileHelper(.large(size: 40))
        print("done: \(Date())")
    }

    private func callReconcileHelper(_ dataSetSize: DataSetSize) {
        var aIn: [Int] = []
        var bIn: [Int] = []

        switch dataSetSize {
        case .small:
            // Simple test data
            aIn = [ 0, 1, 2, 3, 4,       8, 9,        ]
            bIn = [       2, 3,    5, 7, 8,    10, 11 ]
        case .large(let size):
            // Faster than a naive append():
            aIn = Array(repeating: 0, count: size)
            bIn = Array(repeating: 0, count: size)

            (0..<size).forEach { i in
                aIn[i] = Int.random(in: 1..<size/2)
                bIn[i] = Int.random(in: 1..<size/2)
            }
        }

        // Guarantee uniquness of elements, but ensure random ordering
        // Review note: Not the most memory efficient way of ensuring this
        aIn = Array(Set(aIn)).shuffled()
        bIn = Array(Set(bIn)).shuffled()

        print(reconcileHelper(aIn, bIn)) // For smaller datasets
        //reconcileHelper(aIn, bIn) // We may not want to actually see larger datasets (>1000 elements?)
    }
}

/**
 * Given two integer arrays, return a string detailing members of each array that are not
 * present in the other.  The inputs are assumed to contain unique members but have no
 * guarantee of order.
 *
 * The basic algorithm is:
 *
 * 1. Sort the arrays
 * 2. Walk a pair of array indices through the sorted arrays:
 * 3.     At each step determine whether an element is unique to one array or the other, or is common.
 * 4.     Store the unique values in temporary arrays.
 * 5. Once one index has reached the end of its array all remaining elements in the other input array
 *    can be trivially appended to the appropriate output array.
 * 6. Build and return a string containing the results.
 *
 * Review note: In this simple case the above should suffice as an explanation for production code.
 *              At the risk of over-commenting I've added some additional notes, below,
  */
@discardableResult
func reconcileHelper(_ aIn: [Int], _ bIn: [Int]) -> String {

    // Order is not guaranteed; the algorithm depends on the inputs being sorted.
    // Review note: Swift 5 uses a modified TimSort giving O(1) for sorted input, with an upper limit of O(n log n)
    let a = aIn.sorted()
    let b = bIn.sorted()

    // The unique elements in each array
    var ao: [Int] = []
    var bo: [Int] = []

    // The indices
    var ai = 0
    var bi = 0

    // Walk the indices over the arrays until one of them reaches the end
    // O(max(a.count, b.count))
    while ai < a.count && bi < b.count {

        // Walk the 'a' index forwards
        if a[ai] < b[bi] {
            ao.append(a[ai])
            ai += 1
        }

        // Likewise for 'b'
        else if a[ai] >  b[bi] {
            bo.append(b[bi])
            bi += 1
        }

        // The values are equal/common
        else {
            ai += 1
            bi += 1
        }
    }

    // Append any left over values
    // Review note: We could test which index has reached the end and only target the other array
    // but in the worst case we're only unnecessarily appending an empty array.  Having both (without
    // this explanation!) is simplest.
    ao += a[ai..<a.count]
    bo += b[bi..<b.count]

    // Build a return string - inline, space-separated integers.
    // Review note: A better approach, IMHO, would be to return a tuple of results and allow the caller
    // to build the string.
    return """
    Numbers in array a that aren't in array b:
    \(ao.map { String($0) }.joined(separator: " "))

    Numbers in array b that aren't in array a:
    \(bo.map { String($0) }.joined(separator: " "))
    """
}
