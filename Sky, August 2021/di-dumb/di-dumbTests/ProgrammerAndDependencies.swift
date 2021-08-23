//
//  TestHelperClasses.swift
//  di-dumbTests
//
//  Created by Robin Macharg2 on 07/08/2021.
//
// Note: Things are declared public here because the classes are used by the main app to save repetition.

import Foundation

/**
 * As a boss, I like to know what the minions are up to
 */
public protocol Boss {
    func progressUpdate(progress: String)
}

/**
 * A programmer.  Programmers need two things: Coffee and a Computer.
 * They also waste time randomly tapping the keyboard.  Luckily for us it's in the background
 * and doesn't affect the most important thing: telling the boss how they're getting on
 * with the DI task.
 */
public class Programmer {

    public typealias DayStarted = Bool

    public var computerFactory: () -> Computer = { fatalError("Compuer factory must be injected") }
    public var coffeeFactory: () -> Coffee? = { fatalError("Coffee factory must be injected") }

    // One computer
    public var computer: Computer!

    // Many, many cups of coffee may be brewed
    public var coffee: Coffee { coffeeFactory()! }
    public var boss: Boss!

    required public init() {}

    public func startTheDay() -> DayStarted {

        coffee.percolate()
        let caffination = coffee.drink()
        let computerIsOn = computer.turnOn()

        // This next bit may not be the best way of expressing it.  There's likely a "brain of a programmer"
        // dependency that would better express it, but hopefully you get the idea.

        if computerIsOn {
            if caffination > 20 {
                DispatchQueue.global().async {
                    self.codeLikeTheWind()
                }
                updateTheBoss(
                    message: "Awesome day, loving the Cocoa",
                    caffination: caffination,
                    computerState: computerIsOn)
                return true
            }
        }

        updateTheBoss(
            message: "Cut myself on C#",
            caffination: caffination,
            computerState: computerIsOn)
        return false
    }

    private func updateTheBoss(message: String, caffination: Int, computerState: Bool) {
        boss?.progressUpdate(progress: "\(message), caffeine: \(caffination), computer is: \(computerState ? "on" : "off")")
    }

    public func brewCoffee() -> Coffee? {
        guard let coffee = coffeeFactory() else {
            return nil
        }
        return coffee
    }

    private func codeLikeTheWind() {
        print("Tappety tap tap McTapster.  Ship it.")
    }
}

public protocol Computer {
    func turnOn() -> Bool
}

public class Mac: Computer {
    required public init() {}
    public func turnOn() -> Bool {
        print("<Godly Chime> It just works.")
        return true
    }
}

public class PC: Computer {
    required public init() {}
    public func turnOn() -> Bool {
        print("<Bump and Grind> Where do you want to go today?")
        return false
    }
}

public protocol Coffee {
    init()
    typealias Caffination = Int
    func percolate()
    func drink() -> Int
}

public class Caffeinated: Coffee {
    required public init() {}
    public func percolate() {}

    public func drink() -> Caffination {
        return 100
    }
}

public class Decaf: Coffee {

    required public init() {}
    public func percolate() {}

    public func drink() -> Caffination {
        return 0
    }
}

// Unused
//protocol Language {}
//class SwiftLang: Language {}
//class CSharpLang: Language {}
