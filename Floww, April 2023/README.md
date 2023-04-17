# Floww Exercise

Evaluation Task for Floww, April 2023

Submitted by Robin Macharg (robin.macharg@gmail.com)

- Written with Xcode 14.1, on an M1 MBP, targetting iOS 16.1.  Destinations left as the default (iPhone, iPad, Mac)
- Signing will likely need updated before running on a real device.
- The exercise spec. can be found alongside this README.  Both are included at the top-level of the Xcode project
  for convenience.
  
## Development log

Development proceeded as follows:

- Create project, with tests and source control, no CoreData.
- Create README.  Copy in project spec.
- Investigate the CoinGecko Free API.  Create Postman collection.  Add the initial query. 
- Create initial CoinGecko Codables for the two query responses using [Quicktype](https://app.quicktype.io/).  
  Place these in a `Model/CoinGecko` subdirectory.

- Build the `MarketListScreen`, as well as the required API machinery.
  - Basic NavigationStack to get going.
  - Modified the `CGMarket` Codable date fields.  Swift default ISO1601 formatting has issues with milliseconds so
    added a custom formatter.
  - Tests make use of canned JSON files.  Initially in the test bundle but may move to the main bundle, protected by
    `#if DEBUG`s, if they're useful for previews.
  - Added a basic logging class.
  - Decided initially to go with a LazyVList, at the expense of not having pull-to-refresh.
  - Checked dark mode appearance and made some adjustments.
  - Added swiftlint and associated config
  - Prior to an initial commit added an Xcode-oriented .gitignore
  - Initial functional commit. 

- Build the `PriceChartScreen`.
  - Build the viewModel, fleshed out the API for this endpoint and ensured I was getting data back.  The market is
    provided with simple init-based injection.
  - I've not had the opportunity to play with Swift Charts so a quick browse of a Kodeco tutorial got me going.  Some
    issues around the data format were sorted with a quick search and a SO answer.
  - Got a basic line chart working, with suboptimal axis labels.
  - Started to flesh out the View, adding the header info.
  - Moved the image display into a separate MarketImage View since it's reused in this screen.
  - Moved the loading overlay into a separate configurable View since it's reused.
  - Polished the axis display
  - Created the AppIcon from the blue website svg logo, Sketch and an online icon generator.
  - Added tests, moved the mock-related code to the main bundle, polished Previews to use mock data.
  - Changed test parallelisation to serial for convenience.
  - Committed.
  
- Stretch goals.
  - Loading/Error states were added as I went through the main task.
  - Added range picker, associated viewModel enum and properties, modified API to handle configurable days param.
    Adjusted model in light of some missing (optional but unused) data.  Updated/extended axis mark formatters to give
    sane/useful values for differing ranges.  Note: There's an assumption around ranges - I used naive multiples of 365
    days for expediency.  No exact date calcs were performed.
  - Committed.
  - Added the drag/tap gesture highlight.  Further modularised the chart component as part of this.
  - Committed.
  - Added .searchable() modifier to the markets list, updated view model to support filtering.  Pull down on the market 
    list to filter.
  - Committed.
  - Added simple `.refreshable()` modifier to the markets ScrollView to enable pull-to-refresh.  Adjusted the Markets 
    view to show the 'loading' overlay when reloading market data.
  - Committed. 
  - Added horizontal `RuleMark`, as per the spec. screenshot.
  - I considered extending the app to support master-detail better on iPad via `NavigationSplitView`, but after initial
    investigation considered a correct implementation (managing correct appearance/disappearance of the master 
    sideview) decided that pragmatism and concerns over time meant that I couldn't do it justice and so - as indicated
    by the recruiters comments in an email - it was OK to leave this unimplemented.  The app works well on an iPad
    but would be better with a proper master-detail split view.
  - Added Postman query collection to project.
  - Committed.
  - After sleeping on it some final polishing: added launch screen.  Commented-out lower timeout on API calls.  
    Updated double formatting.  Fixed filter capitalisation and autocorrect. Tweaked the y-axis labels.
  - Committed.  Submitted. 
    
## Additional notes

- I've kept a simple MVVM architecture, appropriate to the scale of the app.  A more complex app would justify a more 
  complex architecture.  TCA/Clean would be a prime candidate if I were to extend it to support iPad master-detail
  more fully.
- Testing is rudimentary; I focussed on features.  UI testing is absent.  I've concentrated on models and utility
  functions.
- The model code is likely missing some optionals, but is based on a brief scan of the API docs and IRL testing.  
  What's there works with the data provided.
- Light/Dark mode support is there for the majority of the app; It's subjective (grey is often good enough) and there 
  may be omissions due to time constraints.  If you find them, please let me know!
- I've skipped persistence completely - it wasn't on the spec. and appears outside the scope of theis exercise.
- Project structure:
  - **Top-level** - App, main ContentView, assets.
  - **API** - Communication with the CoinGecko API
  - **Model** - CoinGecko Codables
  - **Screens** - The two screens, with associated viewmodels.  There are also a couple of reused sub-Views.
  - **Extensions** - Additional convenience functionality on native types: Date, DateFormatting and Double.
  - **Utility** - Utility classes/functionality: console logging
  - **Preview Content** - Helper mocks and bundle loading utility classes/functions used by Previews and Tests.
