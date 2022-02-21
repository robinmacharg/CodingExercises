//
//  IGFxError.swift
//  igFxRelated
//
//  Created by Robin Macharg on 18/02/2022.
//

import Foundation

/**
 * Represents the errors that might be reported by the app
 */
enum IGFxError: Error {
    case generalError(String? = nil)
    case networkError(String? = nil)
    case dataError(String? = nil)
    
    private struct errorTexts {
        static let generalError = "An unknown error occurred"
        static let networkError = "There was a problem retreiving data"
        static let dataError = "There was a problem parsing the data"
    }
    
    var description: String {
        var description: String
        switch self {
        case .generalError(let detail):
            description = "\(errorTexts.generalError): \(detail ?? "(No more details provided)")"
        case .networkError(let detail):
            description = "\(errorTexts.networkError): \(detail ?? "(No more details provided)")"
        case .dataError(let detail):
            description = "\(errorTexts.dataError): \(detail ?? "(No more details provided)")"
        }
        return description
    }
}
