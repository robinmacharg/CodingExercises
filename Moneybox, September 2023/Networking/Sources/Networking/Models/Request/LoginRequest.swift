//
//  LoginRequest.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import Foundation

// MARK: - LoginRequest
public struct LoginRequest: Encodable {
    public let email: String
    public let password: String
    let idfa: String = "ANYTHING"

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case password = "Password"
        case idfa = "Idfa"
    }
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
