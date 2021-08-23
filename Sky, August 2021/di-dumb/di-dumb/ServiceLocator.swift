//
//  ServiceLocator.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 07/08/2021.
//

import Foundation

public class ServiceLocator {

    // Singleton
    public static let shared = ServiceLocator()

    // Private to support the singleton pattern
    private init() {}

    static func foo() {
        
    }
}
