//
//  Container.swift
//  di-dumb
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import Foundation

public enum ContainerError: Error, Equatable {
    case generalError(String)
    case factoryError
    case registrationError

    public struct errorTexts {
        public static let generalError = "An Unknown Error occurred"
        public static let noSuitableFactoryFound = "No Suitable Factory Found"
        public static let duplicateRegistrationAttempted = "Attempted to register an already registered type"
    }
}

/**
 * A dependency container.
 * Includes dependency registration and resolution functions.
 * Supports instance and factory dependencies.
 * Supports chaining of registrations
 */
public struct Container: Resolver {

    var factories: [AnyServiceFactory] = []

    public init() {}

    private init(factories: [AnyServiceFactory]) {
        self.factories = factories
    }

    public func reset() -> Container {
        return .init(factories: [])
    }

    // MARK: Register

    /**
     * Register a single instance to be resolved for a type.
     *
     * - Parameters:
     *     - interface: The type to register the instance for resolution for.
     *     - instance: The specific instance to resolve for the supplied type.
     */
    @discardableResult
    public func register<T>(_ interface: T.Type, instance: T) throws -> Container  {
        do {
            return try register(interface) { _ in instance }
        }
        catch let e {
            throw e
        }
    }

    /**
     * Register a factory closure for producing dependencies on-demand.  Allows for external logic to be
     * applied to dependency resolution.
     *
     * - Parameters:
     *     - type: The dependency type to register for
     *     - factory: A factory closure that can generate instances of the type on demand.
     * - Returns: An instance of self
     */
    @discardableResult
    public func register<ServiceType>(_ type: ServiceType.Type, _ factory: @escaping (Resolver) -> ServiceType) throws -> Container   {
        // Check we're not already registered for this type
        if factories.contains(where: { $0.supports(type) }) {
            throw ContainerError.registrationError
        }

        assert(!factories.contains(where: { $0.supports(type) }))

        let newFactory = BasicServiceFactory<ServiceType>(type, factory: { resolver in
            factory(resolver)
        })
        return .init(factories: factories + [AnyServiceFactory(newFactory)])
    }

    // MARK: Resolver

    /**
     * Resolve a dependency for a given type by calling the appropriate factory method.
     *
     * - Parameters:
     *     - type: The type to resolve the dependency for
     */

    // TODO: Try throws
    // TODO: handle recursion

    public func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType? {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
            return nil //.failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
//            fatalError(Errors.noSuitableFactoryFound)
        }
        return factory.resolve(self)
    }

    /**
     * Resolve a factory for a given type.
     *
     * - Parameters:
     *     - type: The type to resolve the dependency for
     * - Returns: The factory that can produce instances of `type`
     */
    public func factory<ServiceType>(for type: ServiceType.Type) -> () -> ServiceType?  {
        guard let factory = factories.first(where: { $0.supports(type) }) else {
//            return failure(ContainerError.generalError(ContainerError.errorTexts.noSuitableFactoryFound))
            fatalError(ContainerError.errorTexts.noSuitableFactoryFound)
        }

        return  { factory.resolve(self) }
    }
}
