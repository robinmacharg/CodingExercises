#  Dependency Injection Coding Task - Submission Notes

Please see the main README file for a description of the problem that this project addresses.

Please address any questions to Robin Macharg: robin.macharg@gmail.com

A note on the name: `di_dumb` is a simple Dependency Injection framework.  I took the drum threme and ran with it, hence the app being called Bdum Tish.
At one point there was also an alternative Drumroll framework but that's mercifully been elided.  `di_dumb` is not a great name and does lead to some weirdnesses
where underscores and hyphens are substituted automatically by Xcode during project setup.

## Examplar app

An example app that makes use of the framework is included.  I've eschewed dependency management (e.g. Cocoapods, SPM etc.) and simply included the 
framework project directly in the examplar app.

Tests are limited to the framework.  App logic is minimal (a single simple View Controller) and not the issue explored here. For expediency both project and 
framework share a file of example classes used to illustrate dependency.  These are simple classes with only sufficient logic to show of aspects of the DI. 

Note: For both targets, below, you may have to adjust the app/framework signing. Xcode should prompt you appropriately.

To run the app:
- Open the `.xcodeproj` project
- (Optionally, select the framework build scheme and build that.  It is included as a project dependency of the app 
  so should build automatically, but, you know, Xcode)
- Select the app build scheme and run that.
- Two types of programmer are defined in the app (Mac and PC) with their relative dependencies injected at runtime.  Clicking either of the buttons sets up a 
  programmer and starts their day.  How the day goes is down to their dependencies. Bad programmers _will_ blame their tools.

To run the DI tests:
- Open the main `.xcodeproj` project
- Select the framework build scheme
- Run all tests (&#8984;-U)

## Design

There are several definitions of DI, increasing in complexity, for instance:

1. Initializer-based Dependency Injection
2. Property-based Dependency Injection
3. Method-based Dependency Injection
4. Service-Locator based Dependency Injection
5. Property Wrapper-based Dependency Injection

Options 1 & 2 don't really require a framework to implement: simply provide arguments to `init()` or make dependency properties 
`public`.  3 is more use-case-specific than I'd like.  I opted for option 4. My experience with DI has been at the level of options 1 & 2 until now, so I reached 
for Google.  The provided solution is based, with modification, on discussion found [here](https://quickbirdstudios.com/blog/swift-dependency-injection-service-locators/).  
This provided a Container-based solution that supported instance and factory-based dependency injection via configurable dependency 
containers.  It has some limitations I discuss below but answers the main task requirement of a basic dependency injection framework.

Option 4 uses new Swift features that I've not had time to play with as yet, but look to provide - with caveats - a clear way to declare injectable properties.

The simplest, most likely correct solution to this problem is to use a predefined library such as [Swinject](https://github.com/Swinject/Swinject) or 
[Resolver](https://github.com/hmlongco/Resolver).  That's not what was asked for so I took the middle ground - embrace and extend.

## Architecture

The DI framework is based on discussion and associated playground mentioned above, and uses a Service Locator pattern.  I've taken the individual object 
definitions and split them into separate files pragmatically, along basic DI/Service Locator patttern lines.

## Limitations/Issues

- The code was developed primarily on Xcode 12.5, on Big Sur, targetting an iPhone Simulator on iOS 14.5.  The framework has no specific iOS dependencies.
- There is currently no explicit handling of circular dependencies although their presence and failure to resolve are exposed in a test.  Looking at how existing 
  frameworks (e.g. Swinject, Unity) handle this, a possible solution is to defer resolution until the object is required.  Detecting and handling non-deferred circular 
  dependencies at runtime would require tracking resolution depth during resolution, perhaps via internal `_resolve()` methods.  Swinject makes use of a
  `ServiceEntry` class that holds dependencies (instances, factories) and allows calling `initCompleted()` on them to achieve deferrment.
- As stated above the framework does not explicitly supoprt keyed property or method-based injection.  
- Provision of dependency tags or additional resolution-time arguments for e.g. `init()`-based non-dependency properties is not implemented. 
- Threading has not been considered.  Some form of synchronisation/locking may be beneficial where cross-thread access is an issue.
- Similarly I've not given due consideration to memory management.
- Error handling (e.g. failed resolution) is limited - `nil` is returned.  This should ideally throw to allow structured handling.  A Result<> type was tried but was too 
  unwieldy, placing the burden of explicit `get()` calls on the implementer.
- Current extensibility is met through the use of factories which provide flexible runtime configuration of dependencies.  Notes above indicate some of the ways the
  framework could be extended (e.g. tags, arguments/argument closures).  There is a `reset()` method but no ability to remove or replace specific dependencies.  
  There's no global dependency register - all dependency-configuring classes have, ironically, a dependency on the DI framework.
- Documentation/comments is extensive if not complete.  I've erred on the side of over-documentation to show thinking.  In production code this would be reduced 
  to answer "why?" questions.  Code could always be clearer but I hope what I've included is ideomatic.
- The main DI functionality is expressed via structs, and allows fluent composition.  I'd probably rewrite this to use classes given the time.
- I've commited code regularly but without branching due to the simple scope.  Commits labelled "WIP/Transfer" allow moving development to a separate computer.
  I've not tried to tidy up history, again due to the scope of the work.

## Using the framework in your own project

### Include the framework in your project

Ensuring that the `di-dumb` project is closed, in your app, drag the `di_dumb.xcodeproj` into your app's project navigator.  Additionally youmay want to drag the 
built framework into your project's dependencies either under General or Build Phases sections of the project config. 

### Incorporate the framework in your code

Example code: 

```
import di_dumb

let container = Container()
    // Instance-based resolution
    .register(YourObjectProtocol.self, instance: YourObject())
    
    // Fluent composition, Factory-based resolution
    .register(YourOtherObject.self) { resolver -> YourOtherObject in
        let yourOtherObject = YourOtherObject()
        yourOtherObject.firstDependency = resolver.resolve(YourObjectProtocol.self)
        yourObjectFactory = resolver.factory(YourObjectProtocol.self)
        yourOtherObject.secondDependency = yourObjectFactory()
    }
let object = container.resolve(YourObjectProtocol.self)
```

The ViewController in `Bdum Tish` has a fuller working example. 

## References

* https://betterprogramming.pub/taking-swift-dependency-injection-to-the-next-level-b71114c6a9c6
* https://quickbirdstudios.com/blog/swift-dependency-injection-service-locators/
* https://github.com/Swinject/Swinject
* https://github.com/hmlongco/Resolver

## TODO

- Change Result<> to ServiceType? DONE
- Change resolution to throwing
- Explore circular dependencies
- Explore property decorators
- SPM?
