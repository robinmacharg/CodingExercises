import Foundation
import XCTest

// Collected algorithmic/maths problem solutions

// MARK: - Smallest missing integer
//
// Find the smallest missing positive integer from a list
// Originally a live coding chat with RelayTech, 2023/09/13
// Online extended version: https://edabit.com/challenge/fmLH2pt2jWeyHxc7H

/**
 * v1, Iterative
 */
func smallestMissingIterative(_ numbers: [Int]) -> Int {
  let sorted = Set(numbers).sorted().enumerated()
  var smallest = 1

  for (i, v) in sorted {
    let expected = i + 1
    let actual = v

    if actual != expected {
      return expected
    }
    smallest = expected + 1
  }
  return smallest
}

/**
 * v2, Sets
 */
func smallestMissingUsingSets(_ numbers: [Int]) -> Int {
  let allNumbers = Set(1...(numbers.count + 1))
  let input = Set(numbers)
  let difference = allNumbers.subtracting(input)
  return difference.min() ?? 1
}

class TestSmallestMissing: XCTestCase {
  func testSmallestMissing() {
    for smallestMissing in [smallestMissingIterative, smallestMissingUsingSets] {
      XCTAssertEqual(smallestMissing([2, 1, 3]), 4)
      XCTAssertEqual(smallestMissing([1, 2, 2, 2, 6, 9]), 3)
      XCTAssertEqual(smallestMissing([2, 3, 5]), 1)
      XCTAssertEqual(smallestMissing([]), 1)
      XCTAssertEqual(smallestMissing([5, -1, -7, 9, 4]), 1) // Negative ints are supported
    }
  }
}

TestSmallestMissing.defaultTestSuite.run()

// MARK: - Server Allocator
//
// Make use of the smallest-missing in a naive server name allocation scenario

/// Mange allocation of servers, including auto generation of names, preserving a minimal pool of names
/// Server names should be alphanumeric, and end in a non-numeric character.
class ServerAllocator {

  /// A regex that matches on "(serverName)(integer ID)"
  private let capturePattern = /^(?<serverType>.*)(?<id>\d+)$/

  /// A function or closure to call to determine the next ID to use for a server
  private let idAllocator: ([Int]) -> Int

  /// Our list of servers
  private var servers: [String : [Int]] = [:]

  init(idAllocator: @escaping ([Int]) -> Int) {
    self.idAllocator = idAllocator
  }

  /// Allocate a server name, with number, given a base name
  func allocate(serverType: String) -> String {
    let nextServerNumber = idAllocator(servers[serverType, default: []])
    servers[serverType, default: []].append(nextServerNumber)
    return "\(serverType)\(nextServerNumber)"
  }

  /// Remove a specific named server from our allocation list
  func deallocate(serverName: String) {
    if let serverDetails = try? capturePattern.wholeMatch(in: serverName),
       let number = Int(serverDetails.id)
    {
      let name = String(serverDetails.serverType)
      servers[name]?.removeAll(where: { number == $0 })
    }
  }
}

class TestServerAllocator: XCTestCase {
  func testAllocation() {
    for idAllocator in [smallestMissingIterative, smallestMissingUsingSets] {
      let allocator = ServerAllocator(idAllocator: idAllocator)
      XCTAssertEqual(allocator.allocate(serverType: "apibox"), "apibox1")
      XCTAssertEqual(allocator.allocate(serverType: "apibox"), "apibox2")
      XCTAssertEqual(allocator.allocate(serverType: "apibox"), "apibox3")
      XCTAssertEqual(allocator.allocate(serverType: "second123Server"), "second123Server1")
      XCTAssertEqual(allocator.allocate(serverType: "second123Server"), "second123Server2")

      allocator.deallocate(serverName: "apibox2")
      allocator.deallocate(serverName: "second123Server2")
      XCTAssertEqual(allocator.allocate(serverType: "apibox"), "apibox2")
      XCTAssertEqual(allocator.allocate(serverType: "databox"), "databox1")

      // Check that we only consider the trailing integer ID
      allocator.deallocate(serverName: "second123Server")
      XCTAssertEqual(allocator.allocate(serverType: "second123Server"), "second123Server2")
    }
  }
}

TestServerAllocator.defaultTestSuite.run()
