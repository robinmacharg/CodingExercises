//
//  API.swift
//  Backbase
//
//  Created by Robin Macharg on 08/07/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//

import Foundation

/**
 * A Singleton to deal with the outside world
 */
class API {
    
    static let shared = API()
        
    private init() {}
        
    /**
     * Load data from... wherever.  In our case it's a hardcoded, in-bundle JSON file.
     * In real life this would be a configurable URL and there would be appropriate configuration
     * methods/setup.
     */
    func load() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Hardcoded
//            let baseName = "cities"
            let baseName = "cities_short"
            
            if let path = Bundle.main.path(forResource: baseName, ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let decoder = JSONDecoder()

                    print("Decoding...")
                    
                    do {
                        // Decode the JSON
                        let cities = try decoder.decode([City].self, from: data)
                        print("Decoded \(cities.count) cities")
                        
                        // Add each city to the datastore
                        // Note the generic language - 'add' doesn't imply any specific imolementation
                        // This also makes no attempt to parallelize.
                        for city in cities {
                            _ = DataStore.shared.add(city: city)
                        }
                    }
                    catch {
                        print("Failed to decode JSON")
                    }
                }
                catch {
                     print("Failed to load cities resource")
                }
            }
            DataStore.shared.finalize()
            NotificationCenter.default.post(name: .endLoadingData, object: nil)
        }
    }
}
