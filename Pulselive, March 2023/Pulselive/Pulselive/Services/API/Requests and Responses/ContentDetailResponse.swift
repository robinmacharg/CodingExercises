//
//  ContentDetailResponse.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//
// Note: generated with quicktype (https://app.quicktype.io/)
//
// Represents a response when querying for article details.
//

import Foundation

// MARK: - PLContentDetail
public struct PLContentDetail: Codable {
    let item: PLContentDetailItem

    enum CodingKeys: String, CodingKey {
        case item
    }
}

// MARK: - PLItem
public struct PLContentDetailItem: Codable {
    let id: Int
    let title: String
    let subtitle: String
    let body: String
    let date: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case body
        case date
    }
}
