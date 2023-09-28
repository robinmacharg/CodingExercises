//
//  LoginError.swift
//  MoneyBox
//
//  Created by Robin Macharg on 27/09/2023.
//

import Foundation

/**
 * Error states when logging in
 */
enum LoginError: Error, Equatable {
    case loginFailed(String)
    case loginDetailNotProvided
}
