# Pulselive-task

Evaluation task for Pulselive, 03/2023

Submitted by Robin Macharg (robin.macharg@gmail.com) 

- Written with Xcode 14.1, on an M1 MBP, targetting iOS 16.1.  Destinations left as the default (iPhone, iPad, Mac)
- Signing will likely need updated before running on a real device.

## Dependencies

- [Resolver](https://github.com/hmlongco/Resolver) - Simple dependency injection

## Assumptions

- w.r.t. **Readability, maintainability and scalability.**, as per the task instructions: 
    - I've erred on the side of over-commenting code to highlight the thinking involved, and trying to answer the 
      "why?" questions.  
    - Minimal tests are included to increase maintainability.
    - I've assumed that this task is part of a larger app and structured code accordingly.  e.g. Files may be nested in 
      structural directories, and split apart into extensions.  I've also added standard tooling as I would for a 
      larger project, such as Swiftlint.
- I've assumed that the backend responses are representative; there's some defensive coding around failing network 
  requests but without knowing more about the backend I've had to make certain assumptions about validity of data. 
  Dates are assumed to be regular across all responses, and of the form "dd/MM/yyyy HH:mm" 
- Tests are necessarily limited in scope; the full range of possible errors cannot be predicted, and certain 
  assumtions around the data have been made.
- While I've integrated Swiftlint I've assumed my own house rules, and there are per-file Swiftlint exceptions based on
  opinionated aesthetic values.
- Freedom was given to use SwiftUI, so I have, with a typical MVVM architecture.  I've not overly componentised the 
  main screens due to their short length but have broken Views into helper properties.  ViewModels are in separate 
  files alongside the screens.
- The phrase "...the app should transition to a detail view..." does not imply a split view master/detail arrangement.  
  I've opted for standard NavigationStack/NavigationLink navigation.
       
## Project structure

The main project directory contains:

- **`README.md`** - this file
- **`LICENSE`** - A standard MIT licence
- The original task specification PDF
- **Pulselive** - The main app directory.  In addition to the `.xcodeproj` project file and tests this is further 
  organised, under `Pulselive` as follows:
  - The main App and initial ContentView
  - **Screens** - The main screens, and supporting ViewModels, one per sub-directory.
  - **Services** - The API service singleton.
  - **Extensions** - Utility extensions to standard Swift foundation classes.
  - **Utility** - Utility classes, e.g. for logging.
  - **Misc** - Miscellanaous files: Assets and an exported Postman collection targetting the backend endpoints.
  - **Preview Content** - The standard Xcode-provided directory. 

## Approach

Brief notes on the approach taken to solving the task.

In summary: 

- Create project
- Create and test API/backend functionality
- Create and test List view
- Create and test Detail view
- Iterate/polish appearance, commenting and notes
- Updated tests to use mocks

More specifically, the development log looks like this:

- Created an empty Git repo with a Swift-oriented `.gitignore`
- Created a SwiftUI project.
- Added Swiftlint build phase
- Added this README and project brief PDF to the Xcode project for convenience.
- Create two screens: `ContentListScreen` and `ContentDetailScreen`, nested in a `Screens` directory.
- Investigate the endpoints with [`Postman`](https://www.postman.com/).  The Postman collection was added to the Xcode 
  project for completeness, and reference.  The List endpoint data seems regular; all keys are included (so Codable 
  optionals not required), and no snake_casing is evident so `CodingKey` support is not strictly required.  I've left 
  it in, however, to address the scalability assumption mentioned above.  Article dates are parsed to a Date type.  The articles have several possible orderings but ascending Date was used.
- Generate initial Codable structures for the endpoints with [Quicktype](https://app.quicktype.io/).  These can be 
  found in `Services/API/Requests and Responses`.  This is a time-saving bootstrapping convenience.  The Codables 
  generated were lightly edited to make the nested types' purpose clearer. 
- Added a standard console logger for more informative debug output.  Standard utility class I have lying around.  A 
  formal 3rd party logging framework was deemed overkill.  Found in `Utility/Logger.swift`.
- Created an API service singleton.  This is moduler and extensible (e.g. endpoints are static properties in a caseless 
  enum in a separate extension).  This was fleshed out as if part of a larger app with separate requests, debug logging 
  etc. Artificial delays have been introduced intentionally to highlight the different UI states.  These can be 
  disabled in the `APIService.makeAsyncRequest()` method.
- Created the `ContentListScreen`.  No style guidance was given so I've opted for simplicity: displaying the title,
  subtitle and date for each item in a left-aligned tappable list.
- Revisit the Codables to address date formatting
- Created the `ContentDetailScreen`.  Again, styling is rudimentary.
- Polished navigation, added a logo to the initial list screen.
- I wasn't happy with the level of testing so went back and added Resolver dependency injection and a mock API.  The
  unit tests were updated to use this. 

## Additional notes

- The `PLContentDetail` Codable model class could skip straight to the item data; not deemed worth it for this example. 
- A light gray Color asset has been added, as has an AppIcon and logo.
- The Logger class is included for convenience but is not really intended to be an assessed part of the task. 
- This was not a massively complicated task, comparable to a single feature, and so commits are fewer than I'd normally
  do.
- Worth stating again that the implementation is more involved than the task really requires, but I was aiming to 
  fulfill the first of the assumptions, above.  To that end a fair bit of machinery was included that would feature in a 
  'real' app (structured networking, logging etc.), without going overboard (I hope!) 
- Testing is fairly minimal - there's not a lot to test, and I wanted to put a limit on time spent.  I've included some 
  dependency injection (Resolver) to allow better mocking of e.g. api calls. 
- There's an artificial delay in the networking code to show the loading spinner.  I opted not to include random 
  failures but there's code included in both API and ViewModels to handle that, as well as rudimentary tests.
- The List screen has automatic article reload after an amount of elapsed time; this may or may not be a desirable
  feature in a full app, but does illustrate the loading spinner.
- The same date format is used for parsing and for display, albeit using differrent `DateFormatter`s.
- #if DEBUG/#endif is used to ensure that mock data does not escape into a production app.
- It was deemed sufficient not to use any persistent data storage, given the contraints of the exercise; data is 
  stored naively as lists/structs in the ViewModels.  The Codable representations were sufficient for this purpose
  so there's no adaptation to internal representations. 
       
## Time spent

Probably 4-5 hours in total.  Some of that obviously spent on polish and these notes.
