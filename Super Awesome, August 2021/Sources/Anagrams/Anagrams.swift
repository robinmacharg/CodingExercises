//
//  Anagrams.swift
//  Anagrams
//
//  Created by Robin Macharg on 04/07/2021.
//

import Foundation

/// Associates an ordered string with a list of found anagrams
private typealias AnagramMap = [String: Set<String>]

public struct Anagrams {
    
    /// The path of the file containing anagrams
    private var filepath: String
    
    /**
     * Retrieve and store the supplied filename from the command line arguments
     *
     * - Parameter arguments: The command line arguments
     */
    public init(filepath: String) {
        
        // Check the file exists and is valid
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: filepath){
            self.filepath = filepath
        }
        else {
            exit(AnagramError.INVALID_FILE)
        }
    }

    /**
     * The main algorithm.  Reads a line at a time and stores the read line in a set, in a dictionary,
     * keyed by the word's sorted anagram.  A set is used to automatically deduplicate anagrams.
     *
     * # Complexity
     *
     * O(n), where n is the number of words in the file.
     */
    public func run() throws {
        /// Temporary storage for anagrams of a certain length
        var anagrams: AnagramMap = [:]
        
        /// The current line length
        var lineLength: Int? = nil
        
        guard let aStreamReader = StreamReader(path: filepath) else {
            print("Unable to read file")
            exit(AnagramError.GENERAL_ERROR)
        }
        
        /// Ensure we clean up prior to exit
        defer {
            aStreamReader.close()
        }
        
        // Iterate over each line in the file, filing the word alongside other anagrams and
        // outputing all words of a certain length when the word length changes.
        while let line = aStreamReader.nextLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            // Words are grouped by length.  Handle the word-length changing.
            if lineLength != line.count {
                if lineLength != nil {
                    outputAnagrams(anagrams: anagrams)
                    anagrams = [:]
                }
                lineLength = line.count
            }
            
            anagrams[String(line.lowercased().sorted()), default: Set<String>()].insert(line)
        }
        outputAnagrams(anagrams: anagrams)
    }
    
    /**
     * Print out the accumulated anagrams
     *
     * - Parameter anagrams: A map of identifier -> list of anagrams
     */
    private func outputAnagrams(anagrams: AnagramMap) {
        anagrams.values.forEach { (words) in
            print(words.joined(separator: ","))
        }
    }
}
