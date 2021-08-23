# di-dumb
A simple Swift Dependency Injection framework

## Submission notes

__Notes on the submitted code design, and its usage can be found [here](README_submission.md).__ 

## Task Description

We would like you to write a simple dependency injection framework in Swift. The solution need not be 
very complex and not every use-case of a DI framework needs to be covered. For example, it is okay to 
support only transient objects and classes (no constants, functions and other types), but it would be
interesting to see how you recognise and deal with circular dependencies. We expect tests to be written, 
but the coverage does not have to be full, as we will just be using them as a point of discussion.

We would like you to focus on:

* Building a library and demonstration of how to use it.
* Basic dependency resolution functionality.
* Good code architecture.
* Extensibility.
* Easy integration and good developer experience (if this were a real project, it would be consumed by 
other developers).

Minimum requirements:
* A framework target that can be imported into another project.
* It should be possible to resolve multiple instances of the desired type (not just a container for initialised objects).
* Tests proving at least basic resolution functionality.
