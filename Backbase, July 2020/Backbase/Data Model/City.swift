//
//  City.swift
//  Backbase
//
//  Created by Robin Macharg on 08/07/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//

import Foundation

/**
 * Represents a city in the world.
 *
 * 1-1 mapping of the JSON structure
 */
class City: Codable {
    struct Coord: Codable {
        var lon: Double
        var lat: Double
    }

    var name: String
    var country: String
    var id: Int
    var coord: Coord
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case id = "_id"
        case coord
    }
}
