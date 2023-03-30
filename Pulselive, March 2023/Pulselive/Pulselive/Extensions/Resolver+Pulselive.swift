//
//  Resolver+Pulselive.swift
//  Pulselive
//
//  Created by Robin Macharg on 29/03/2023.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    
    /**
     * Registers all injectable dependencies
     */
    public static func registerAllServices() {
        register { APIService.shared as APIServiceProviding }
    }
}
