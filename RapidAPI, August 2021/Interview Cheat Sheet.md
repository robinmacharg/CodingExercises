## !!! WIP !!! <!-- omit in toc -->

Notes to myself on common interview topics.  Please look away now if you don't want to know the scores.

# Interview Cheat Sheet <!-- omit in toc -->

- [External cheatsheets](#external-cheatsheets)
- [Artchitecture/Coding Style](#artchitecturecoding-style)
  - [MVC vs MVVM vs MVP vs VIPER](#mvc-vs-mvvm-vs-mvp-vs-viper)
  - [Singletons.  Alternatives (DI)](#singletons--alternatives-di)
  - [Declarative vs Imperative](#declarative-vs-imperative)
- [Async, Promises](#async-promises)
  - [async/await](#asyncawait)
  - [actors](#actors)
- [Leaks/Memory management, weak/strong, detecting cycles](#leaksmemory-management-weakstrong-detecting-cycles)
- [O(Complexity)](#ocomplexity)
- [UIKit, SwiftUI](#uikit-swiftui)
- [Reactive - RxSwift, ReactiveUI, Combine](#reactive---rxswift-reactiveui-combine)
- [SOLID](#solid)
- [Language features](#language-features)
  - [Enum](#enum)
  - [Singleton](#singleton)
  - [Generics](#generics)
  - [Protocol oriented](#protocol-oriented)
  - [Extensions](#extensions)
  - [Class vs Structs](#class-vs-structs)
  - [Mutating](#mutating)
  - [Type constraints with `where`](#type-constraints-with-where)
  - [Rich Switch](#rich-switch)
  - [Functional - `map`, `reduce`, `zip`, `filter`](#functional---map-reduce-zip-filter)
  - [Codable](#codable)
  - [Property Decorators](#property-decorators)
  - [Subscript Syntax](#subscript-syntax)
- [Thread safety](#thread-safety)
  - [Mitigations](#mitigations)
- [Build/Deploy](#builddeploy)
  - [Bitcode](#bitcode)
  - [Signing](#signing)
  - [Deployment](#deployment)
    - [Fastlane](#fastlane)
    - [Firebase](#firebase)
  - [Development Environment](#development-environment)
  - [Package Management](#package-management)
- [Design Patterns](#design-patterns)
- [Testing](#testing)
  - [Unit](#unit)
  - [CI](#ci)
- [Literate coding](#literate-coding)
- [Found Interview Questions](#found-interview-questions)

## External cheatsheets

- [Swift Cheat Sheet](https://mhm5000.gitbooks.io/swift-cheat-sheet/content/index.html)
- [Swift Language Guide](https://docs.swift.org/swift-book/ReferenceManual/AboutTheLanguageReference.html)

## Artchitecture/Coding Style
### MVC vs MVVM vs MVP vs VIPER

MVVM + (Functional) Reactive

### Singletons.  Alternatives (DI)
### Declarative vs Imperative


## Async, Promises
### async/await
### actors

## Leaks/Memory management, weak/strong, detecting cycles

## O(Complexity)

## UIKit, SwiftUI

## Reactive - RxSwift, ReactiveUI, Combine

## SOLID

- **Single-Responsibility Principle**  Each and every class in your project should have one, and only one responsibility.
- **Open-Closed Principle** Entities in your software system should be open for extension, but closed for modification.
- **Liskov Substitution Principle** Functions that use pointers or references to base classes must be able to use objects of derived classes without knowing it.
- **Interface Segregation Principle** Clients should not have to implement interfaces that they don’t use.
- **Dependency Inversion Principle** High level modules should not depend on lower level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions.

## Language features

### Codable/JSON encoding

```

```

### Enum

Errors: 
```
enum CustomError: Error {
    case anError
    case unexpected(message: String)
}
```

### Singleton

```
class Foo {
    static let shared = Foo()
    private init() {}
}
```

### Generics

Generics vs Opaque types - `some` keyword

### Protocol oriented



### Extensions
### Class vs Structs

Inheritance, ObjC interop, Single Instance requirement

### Mutating
### Type constraints with `where`
### Rich Switch
### Functional - `map`, `reduce`, `zip`, `filter`
### Codable 
### Property Decorators
### Subscript Syntax

keys, nested, custom (non-JSON) formats

## Thread safety
- **Race Conditions** 2 or more concurrent accesses to shared data.
- **Deadlock** 2 or more threads waiting for locks to be released.
  
### Mitigations
- Dispatch Barriers
- Dispatch Queue
- Dispatch Semaphore - scquire semaphore, wait to be notified it's OK to access resource.
- NSLock - Acquire lock.  Can cause deadlocks.
- Alternatives to threads: NSOperation, GCD, Async, timer
- TODO: Apple's threading docs.

## Build/Deploy
### Bitcode
### Signing
### Deployment
#### Fastlane
#### Firebase

### Development Environment

- Xcode vs AppCode
- `xcodeselect`
- `xcprofile`
- 

### Package Management
Cocoapods vs. Carthage vs SPM

## Design Patterns
- DI/Service Provider
- Observer
  (Own implementation with introspection)
- Command
- Singleton
  - Valid vs. Invalid cases.  API, DB, Application, Cache?
- Factory
- Adapter



## Testing
### Unit

Unit vs. UI.  Coverage.  Pragmatism.  Death by a thousand swipes.

### CI

## Literate coding

Comments at the Why level.  Playgrounds to highlight features (with `/*: ... */` docs).  Build targets to automate N-offs (localisation, asset compilation, cocoapods (but see also Git hooks)).  Markdown comments.

List processing (``foreach {}`) vs `for/in`. Pragmatic clarity.

## Found Interview Questions

...
