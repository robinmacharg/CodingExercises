//
//  ErrorResponse.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import Foundation

// MARK: - ErrorResponse
public struct ErrorResponse: Codable {
    public let name: String?
    public let message: String?
    public let validationErrors: [ValidationError]?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
    
    public struct ValidationError: Codable {
        public let name: String?
        public let message: String?

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case message = "Message"
        }
    }

}
