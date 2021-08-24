//
//  ViewController.swift
//  Bdum Tish
//
//  Created by Robin Macharg2 on 05/08/2021.
//

import UIKit
import di_dumb

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var progressLabel: UILabel!

    var programmerResolver: Container?

    override func viewDidLoad() {
        super.viewDidLoad()
        progressLabel.text = "Boss says: I'm waiting..."
    }

    // MARK: - Actions

        /**
     * Create a container for a Mac programmer's dependencies and start their day
     * Report back how we did to the boss (this VC is the boss)
     */
    @IBAction func startMacProgrammersDay(_ sender: Any) {
        if let resolver = try? Container()
            .register(Coffee.self, { _ in
                return Caffeinated()
            })
            .register(Computer.self, instance: Mac())
        {
            self.programmerResolver = resolver
            initialiseProgrammerResolver(resolver: resolver)
            doAHardDaysGraft(programmerResolver: self.programmerResolver!)
        }
        else {
            // error handling
        }
    }

    /**
     * Create a container for a PC programmer's dependencies and start their day
     * Report back how we did to the boss (this VC is the boss)
     */
    @IBAction func startPCProgrammersDay(_ sender: Any) {
        if let resolver = try? Container()
            .register(Coffee.self, { _ in
                return Decaf()
            })
            .register(Computer.self, instance: PC())
        {
            self.programmerResolver = resolver
            initialiseProgrammerResolver(resolver: resolver)
            doAHardDaysGraft(programmerResolver: self.programmerResolver!)
        }
        else {
            // error handling
        }
    }

    /**
     * Fully initialise a programmer dependency resolver.
     *
     * - Parameters:
     *     - resolver: A resolver.  In this case it's partially populated with computer and coffee dependencies
     */
    func initialiseProgrammerResolver(resolver: Container?) {
        programmerResolver = try? resolver?
            .register(Boss.self, instance: self)
            .register(Programmer.self) { resolver -> Programmer in
                let programmer = Programmer()

                let coffeeFactory = resolver.factory(for: Coffee.self)
                programmer.coffeeFactory = coffeeFactory

                let computerFactory = resolver.factory(for: Computer.self)
                programmer.computer = computerFactory()

                let boss = resolver.resolve(Boss.self)
                programmer.boss = boss

                return programmer
            }
    }

    func doAHardDaysGraft(programmerResolver: Container) {
        if let programmer = programmerResolver.resolve(Programmer.self) {
            _ = programmer.startTheDay()
        }
    }
}

/**
 * Who's the boss?  We are.  And we expect regular reports on progress
 */
extension ViewController: Boss {
    func progressUpdate(progress: String) {
        DispatchQueue.main.async {
            self.progressLabel.text = progress
        }
    }
}
