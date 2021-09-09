import XCTest
import class Foundation.Bundle
@testable import Anagrams

final class AnagramsTests: XCTestCase {
    
    private var appBinary: URL!
    private var process: Process!
    private var pipe: Pipe!
    
    override func setUp() {
        appBinary = productsDirectory.appendingPathComponent("Anagrams")

        process = Process()
        process.executableURL = appBinary

        pipe = Pipe()
        process.standardOutput = pipe
    }
    
    func testMissingArgumentExitsNonZero() throws {
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(
            process.terminationStatus,
            AnagramError.INCORRECT_ARGUMENTS,
            "Missing argument should cause non-zero exit")
    }
    
    func testOnlySingleArgumentIsValid() throws {
        process.arguments = ["fakeFile1.txt", "fakeFile2.txt"]
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(
            process.terminationStatus,
            AnagramError.INCORRECT_ARGUMENTS,
            "Only a single argument is valid")
    }
    
    func testInputFileDoesNotExistNonZeroExit() throws {
        process.arguments = ["fakeFile1.txt"]
         try process.run()
         process.waitUntilExit()
        
        XCTAssertEqual(
            process.terminationStatus,
            AnagramError.INVALID_FILE,
            "Only a single argument is valid")
    }
    
    func testInputFileExistsZeroExit() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileUrl = testBundle.url(forResource: "example1", withExtension: "txt") else {
            fatalError("The example input file is not available to the test suite")
        }
        
        process.arguments = ["\(fileUrl.path)"]
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(
            process.terminationStatus,
            AnagramError.OK,
            "Input file must exists")
    }
    
    func testSimpleOutput() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileUrl = testBundle.url(forResource: "example1", withExtension: "txt") else {
            fatalError("The example input file is not available to the test suite")
        }
        
        process.arguments = ["\(fileUrl.path)"]
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()

        guard let output = String(data: data, encoding: .utf8) else {
            XCTFail("Unable to get command output")
            return
        }
        
        let outputLines = output.split(separator: "\n").map { String($0) }
        XCTAssertEqual(outputLines.count, 3)
        
        // Ensure that we have each line, and no more.  Anagram ordering is not required for output,
        // but is useful for our comparisons so we sort each line of output.
        
        var expectedLines = ["abc,bac,cba", "fun,unf", "hello"]
        
        for line in outputLines {
            let sortedLine = String(line.split(separator: ",").sorted().joined(separator: ","))
            if expectedLines.contains(sortedLine) {
                if let index = expectedLines.firstIndex(of: sortedLine) {
                    expectedLines.remove(at: index)
                }
                else {
                    XCTFail("Expected to find \(sortedLine) in expected output")
                }
            }
        }
        XCTAssertEqual(expectedLines.count, 0, "Mismatch between expected output and actual.")
    }
    
    func testEmptyFile() throws {
        let testBundle = Bundle(for: type(of: self))
        guard let fileUrl = testBundle.url(forResource: "emptyFile", withExtension: "txt") else {
            fatalError("The example input file is not available to the test suite")
        }
        
        process.arguments = ["\(fileUrl.path)"]
        try process.run()
        process.waitUntilExit()
        
        XCTAssertEqual(
            process.terminationStatus,
            AnagramError.OK,
            "Empty file should exit with 0 status")
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()

        XCTAssertEqual(data.count, 0, "Expected no output")
    }
    
    // MARK: - Helpers
    
    /// Returns path to the built products directory.  Used to locate the app binary.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

}
