//
//  ContentListResponse.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//
// Note: generated with quicktype (https://app.quicktype.io/)
//
// Represents a response when querying for a list of articles.
//

import Foundation

// MARK: - PLList
public struct PLContentList: Codable {
    let items: [PLContentListItem]

    enum CodingKeys: String, CodingKey {
        case items
    }
}

// MARK: - PLItem
public struct PLContentListItem: Codable {
    let id: Int
    let title: String
    let subtitle: String
    let date: Date

    // Not necessary in this example, left for illustration
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case date
    }
}
