//
//  ServiceFactory.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

public protocol ServiceFactory {
    associatedtype ServiceType
    func resolve(_ resolver: Resolver) -> ServiceType
}

public extension ServiceFactory {
    func supports<T>(_ type: T.Type) -> Bool {
        return type == ServiceType.self
    }
}
