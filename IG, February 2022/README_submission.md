#  IG Coding Task Submission Notes

Candidate: Robin Macharg
Date: 2022/02/18

Due to other projects that require older versions of MacOS and Xcode this was completed on a MacBook Air running Catalina (MacOS 10.15.7) using Xcode 12.4.  It targets iOS 13.0+.  The app was written with a portrait iPhone form-factor in mind and due to time constraints no explicit provision for different devices or orientations was made.

The code should be opened in Xcode and the default scheme should simply run on either a simulator or device.

The JSON provided by the endpoints was fairly lengthy and somewhat nested.  To save some time, QuickType (https://app.quicktype.io/) was used to generate Codable and URLSession boilerplate which was then hand-tuned.

## Code structure

The app is broken in to the following main parts:

- View Controllers: Subdivided by screen.  The app uses standard Storyboards and UIKit lifecycle.  There's no SwiftUI.  Each of the two main VCs has a trivial ViewModel.  Strictly not necessary, but left in for further discussion.
- Views: Additional views required, such as table cells.  Again, divided by screen.
- Storyboards.  There's a simple loading screen.  Going against Apple's guidelines, this differs from the initial screen.  This is a personal choice.
- Model: There's a model struct for each of the two main categories of data: Articles and Markets, as well as separate common helper functions.  These models are containers for specific types of data.  There's no persistent database.
- Extensions: At present only a single file containing additonal methods to enable loading indicators on UIViewControllers.
- Misc: Other App-related files: example data for reference, Info.plist, Segue names etc., placed here to avoid cluttering the top-level.

In addition (and in addition to App- and Scene Delegates) there are a couple of top-level files that didn't need separate directories:

- API: a singleton that makes network requests.  The three functions here take a callback to allow the view controllers to handle returned data.
- Errors: Error handling is quick and dirty.  There's an IGFxError enumeration that contains error cases and general text.  Any error-specific descriptions are appended to these texts.

## Approach

I started with the API and model, to ensure I could retrieve and parse the data.  I then fleshed out the storyboard with a TabViewController and decided on appropriate icons.  Next I looked at the Markets screen, since it was the simpler of the two.  A Standard TableViewController was used.  This also opens the market data web page in Safari using the supplied URL.  I then looked at the Articles screen.  Apple advises against using a SplitViewController at anything other than the top-level.  In this case I think the use-case is valid and I did spend some time looking into embedding a SplitVC into the existing Tab structure.  In the end, given the time constraints, I went with the simpler standard navigation controller-based approach.  Pragmatism won.

With the app functional I looked into testing.  There's not a lot to test, so I focussed on the non-graphical aspects.  The API was modified slightly to make the URLSession injectable.  Code to customise a URLSession to perform in a way that allowed testing failure modes was copied liberally from the web.  Testing could be more comprehensive but 4 hours isn't a lot of time.  With hindsight, and perhaps a little more bravery, I would have spent less time on the features and more on testing.  It's difficult to know the relative weighting given to each so I made a judgement call; the app is feature complete and demonstrates async testing. 
    
## Observations

The solution is required to be simple and maintainable.  To this end there is an amount of repetition of boilerplate table view controller code.  In a larger application, and with more time, I'd look to abstract away repeated code such as pull-to-refresh.  Models for standard linear tables would likely be generic with functionality described via protocols.  

UI design was not a requirement and so is minimal and functional.  Pull-to-refresh spinners have been moved below the tables z-order (a single line).  A minimal subset of data is exposed in the UI since it's not clear from the JSON what's useful to the user, and what's intended for consumption by any further (hypohetical) additional server calls.

The server-provided JSON is undocumented and so some assumptions about structure have been made:
- There are only 3 defined markets.  These are treated as special cases.  My assumption is that a separate API would provide e.g. names that map to each Market.  For simplicity `switch`es have been used to differentiate these.
- Likewise, there are only 5 defined categories of Article, and Daily Briefings fall into only 3 geographic zones.

Comments are liberal and may edge towards overly verbose for such a simple project however they're not production comments; instead they also aim to show my thinking and consideration of options.  In an established codebase I'd still comment liberally but state the obvious a little less. I always try and provide both a brief "what?" summary (one line can be read, understood, and the reader can move on) and "why?" summary for non-trivial code where its place or reason for existence may not be immediately obvious.

TODOs indicate where I would expand the app, given more time, and where I achnowledge that the app is, to an extent, not complete.

The Daily Briefings have been flattened up to the top level, sibling with Breaking and Top News, etc.  This provides a uniform list and a minimal UI requirement.  A more sophisticated UI is likely required to best show this data off.  This does mean that e.g. Breaking News typically has zero entries rather than being omitted.  Again, time constraints.

Thanks for taking the time to read.  Any questions should be directed to robin.macharg@gmail.com
