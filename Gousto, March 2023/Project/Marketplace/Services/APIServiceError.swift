//
//  APIServiceError.swift
//
//  Created by Robin Macharg on 01/02/2023.
//

import Foundation

enum APIServiceError: Error {
    case nonHTTPURLResponse
    case non200Response(request: URLRequest?, response: HTTPURLResponse?)
    case unhandledError
    case transportError(Error)
    case jsonDecodingError(structName: String, details: String?)
}

extension APIServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unhandledError:
            return "Unhandled API Service error"
        case .transportError(let error):
            return "API Transport Error\n(\(error.localizedDescription))"
        case .jsonDecodingError(let structName, let details):
            return "API Decoding Error: \(structName) -  \(details?.debugDescription ?? "")"
        default:
            return "Generic APIServiceError"
        }
    }
}
