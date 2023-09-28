//
//  Login.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import Foundation

public extension API {
    enum Login: AppNetworkable {
        case login(request: LoginRequest)
        
        public var request: URLRequest {
            switch self {
            case let .login(request):
                return getRequest(with: "/users/login", encodable: request, httpMethod: .POST)
            }
        }
    }
}
