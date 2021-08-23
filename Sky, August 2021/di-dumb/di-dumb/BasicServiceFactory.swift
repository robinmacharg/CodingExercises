//
//  BasicServiceFactory.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

struct BasicServiceFactory<ServiceType>: ServiceFactory {
    private let factory: (Resolver) -> ServiceType

    init(_ type: ServiceType.Type, factory: @escaping (Resolver) -> ServiceType) {
        self.factory = factory
    }

    func resolve(_ resolver: Resolver) -> ServiceType {
        return factory(resolver)
    }
}
