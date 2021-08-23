//
//  Errors.swift
//  Superheroes
//
//  Created by Robin Macharg2 on 02/08/2021.
//
//  Declare possible errors in the application, colocated with (non-localized) error texts

import Foundation

enum SuperHeroError: Error {
    case generalError(String)
    case failedToEncode
    
    struct errorTexts {
        static let generalError = "An Unknown Error occurred"
        static let urlError = "Unable to generate endpoint URL"
    }
}
