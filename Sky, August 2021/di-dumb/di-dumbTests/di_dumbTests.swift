//
//  di_dumbTests.swift
//  di-dumbTests
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import XCTest
@testable import di_dumb

class di_dumbTests: XCTestCase {

    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    /**
     * Test that we can reset a container
     */
    func testContainerReset() throws {
        var resolver1 = Container()
        XCTAssertEqual(resolver1.factories.count, 0)
        resolver1 = try! resolver1.register(Computer.self, instance: Mac())
        XCTAssertEqual(resolver1.factories.count, 1)
        resolver1 = try!resolver1.register(Coffee.self, instance: Decaf())
        XCTAssertEqual(resolver1.factories.count, 2)

        var resolver2 = Container()
        XCTAssertEqual(resolver2.factories.count, 0)
        resolver2 = try!resolver2.register(Computer.self, instance: PC())
        XCTAssertEqual(resolver2.factories.count, 1)
        resolver2 = try! resolver2.register(Coffee.self, instance: Caffeinated())
        XCTAssertEqual(resolver2.factories.count, 2)

        resolver1 = resolver1.reset()
        XCTAssertEqual(resolver1.factories.count, 0)
        XCTAssertEqual(resolver2.factories.count, 2)

        resolver2 = resolver2.reset()
        XCTAssertEqual(resolver1.factories.count, 0)
        XCTAssertEqual(resolver2.factories.count, 0)

        resolver1 = try! resolver1.register(Computer.self, instance: Mac())
        XCTAssertEqual(resolver1.factories.count, 1)
    }

    func testFailingResolution() throws {
        let resolver = Container()

        if resolver.resolve(Coffee.self) != nil {
            XCTFail()
        }
    }

    func testCanRegisterAndResolveInstance() throws {
        let resolver = try! Container()
            .register(Coffee.self, instance: Caffeinated())
            XCTAssertTrue(resolver.resolve(Coffee.self)! is Caffeinated)
    }

    func testDoubleRegistrationFails() throws {
        XCTAssertThrowsError(try Container()
            .register(Coffee.self, instance: Caffeinated())
            .register(Coffee.self, instance: Caffeinated()))
        { error in
            XCTAssertEqual(error as? ContainerError, .registrationError)
        }
    }

    func testCanRegisterAndResolveWithFactoryClosure() throws {
        let resolver = try! Container()
            .register(Coffee.self, { resolver in
                XCTAssertTrue(resolver is Container)
                return Caffeinated()
            })

        XCTAssertTrue(resolver.resolve(Coffee.self)! is Caffeinated)
    }

    func testCanRegisterAndFailsWithUnregsiteredFactory() throws {
        try! Container()
            .register(Coffee.self) { resolver in
                let factory = resolver.factory(for: Caffeinated.self)
                
                if factory() != nil {
                    XCTFail()
                }

                fatalError("Unexpected execution")
            }
    }

    func testCanRegisterAndSucceedsWithRegsiteredFactory() throws {

        // Set up a container for injecting all the good things a Mac programmer needs
        let macResolver = try! Container()
            // Coffee factory
            .register(Coffee.self) { _ in
                return Caffeinated()
            }
            .register(Computer.self, instance: Mac())
            .register(Programmer.self) { resolver in
                let programmer = Programmer()

                let coffeeFactory = resolver.factory(for: Coffee.self)
                programmer.coffeeFactory = coffeeFactory

                let computerFactory = resolver.factory(for: Computer.self)
                programmer.computer = computerFactory()

                return programmer
            }

        guard let macProgrammer = macResolver.resolve(Programmer.self) else {
            XCTFail()
            return
        }

        XCTAssertTrue(macProgrammer.coffee is Caffeinated)
        XCTAssertTrue(macProgrammer.computer is Mac)

        let firstCoffee = macProgrammer.brewCoffee()
        let secondCoffee = macProgrammer.brewCoffee()
        XCTAssertFalse(firstCoffee as? Caffeinated === secondCoffee as? Caffeinated)

        let goodDayAtTheOffice = macProgrammer.startTheDay()
        XCTAssertTrue(goodDayAtTheOffice)

        // PC
        let pcResolver = try! Container()
            .register(Coffee.self, instance: Decaf())
            .register(Computer.self, instance: PC())
            .register(Programmer.self) { resolver in
                let programmer = Programmer()

                let coffeeFactory = resolver.factory(for: Coffee.self)
                programmer.coffeeFactory = coffeeFactory
                let computerFactory = resolver.factory(for: Computer.self)
                programmer.computer = computerFactory()

                return programmer
            }

        guard let pcProgrammer = pcResolver.resolve(Programmer.self) else {
            XCTFail()
            return
        }

        XCTAssertTrue(pcProgrammer.coffee is Decaf)
        XCTAssertTrue(pcProgrammer.computer is PC)

        let firstPCCoffee = pcProgrammer.brewCoffee()
        let secondPCCoffee = pcProgrammer.brewCoffee()
        XCTAssertTrue(firstPCCoffee as? Caffeinated === secondPCCoffee as? Caffeinated)

        let notAGoodDayAtTheOffice = pcProgrammer.startTheDay()
        XCTAssertFalse(notAGoodDayAtTheOffice)
    }

    // Uncomment to expose circular dependency deficiency
//    func testCircularDependency() throws {
//        let resolver = try! Container()
//            .register(A.self) { resolver in
//                let ai = AInst(b: resolver.resolve(B.self)!)
//                return ai
//            }
//            .register(B.self) { resolver in
//                let bi = BInst(a: resolver.resolve(A.self)!)
//                return bi
//            }
//
//        // Infinite recursion
//        let a = resolver.resolve(A.self)
//    }
}

// MARK: - Supporting classes to expose circular dependency deficiency

protocol A {
    var b: B { get set }
}

class AInst: A {
    var b: B

    init(b: B) {
        self.b = b
    }
}

protocol B {
    var a: A { get set }
}

class BInst: B {
    var a: A

    init(a: A) {
        self.a = a
    }
}
