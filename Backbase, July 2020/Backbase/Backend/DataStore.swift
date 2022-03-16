//
//  DataStore.swift
//  Backbase
//
//  Created by Robin Macharg on 08/07/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//
// A singleton data storage class.  This abstracts the real underlying
// data storage mechanism.

import Foundation

/**
 * A datastore
 */
class DataStore {
    
    // MARK: - Singleton
    
    static let shared = DataStore()
    
    // MARK: - Properties
    
    // Private
    
    // O(1) search
    private var cities: Dictionary<String, [City]> = [:]

    // A list of (name, City) tuples amenable to sorting
    private var allCities: [City] = []
    
    // Public
    
    var count: Int = 0
    
    // MARK: - Interface
    
    /**
     * Add a city to the datastore
     *
     * - Parameter city: The city
     * - Returns whether the city was added successfully
     */
    func add(city: City) -> Bool {
        let lowercased = city.name.lowercased()

        // Degenerate case
        if lowercased.count == 0 {
            return false
        }
        
        count += 1
        allCities.append(city)
        
        // Add an entry.  We store our city multiple times, once for each substring:
        // i.e. for London, store under "l", "lo", "lon", "lond" etc.
        for end in 1...lowercased.count {
            let lowerBound = lowercased.index(lowercased.startIndex, offsetBy: 0)
            let upperBound = lowercased.index(lowercased.startIndex, offsetBy: end)
            let partial = String(lowercased[lowerBound..<upperBound])
            
            if cities[partial] == nil {
                cities[partial] = [city]
            }
            else {
                cities[partial]?.append(city)
            }
        }
        
        // Progress
        if count % 10000 == 0 {
            print("Added \(count) cities to the datastore")
        }
        
        return true
    }
    
    /**
     * Perform any final manipulation of the datastore, presorting etc.
     */
    func finalize() {
        print("Sorting cities...")
        allCities.sort { $0.name < $1.name }
        print("Done.")
        
        // Stats:
        print("Total dictionary entries: \(cities.count)")
        
        // Sort individual sub-arrays
        var count = 0
        for (k, v) in cities {
            cities[k] = v.sorted { $0.name < $1.name }
            
            count += 1
            if count % 10000 == 0 {
                print("Sorted \(count) subarrays")
            }
        }
        
        // Stats, for interest.
        // Comment out for "production"
        // 's' is the largest, with 24435 elements.
        let largestSublist = cities.reduce((0, "<NA>")) { (countAndCity, element) -> (Int, String) in
            if element.value.count > countAndCity.0 {
                return (element.value.count, element.key)
            }
            return countAndCity
        }
        print("Largest sublist is '\(largestSublist.1)' with \(largestSublist.0) elements")
    }
    
    /**
     * Perform the search.  Most of the hard work is done by the dataprep.
     */
    func search(text: String? = nil) -> [City] {
        
        // empty search returns all cities in alphabetical order
        guard let searchString = text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  searchString.count > 0 else
        {
            return allCities
        }
        
        return cities[searchString.lowercased()] ?? []
    }
}
