#  PAW Coding Task - Submission notes

This README contains additional explanatory notes relating to the PAW "Superhero" coding task.  

0. Running the app: It should be sufficient to open the `.xcodeproj`, adjust signing and run the app.  If you're using Little Snitch or similar proxy you may have 
additional configuration. Press the "Submit POST request" button repeatedly.  Selection in the LHS pane will show a tree view in the RHS one when data has arrived.

1. Ordinarily the code would be pragmatically minimal, and any in-code documentation would be focussed at a competent developer level, with an assumption that
code had undergone review for clarity and correctness.  In the absence of (immediate) review and explanatory pull request notes I've opted to add additional commentary
in-line in the code.  These comments may be seen as overkill and I'd beg the reviewer's understanding.

2. "Keep history of requests/responses and allow to switch between them;" - This is ambiguous. Ordinarily I'd seek clarity, but given the scope of the exercise my 
interpretation is that we should be able to switch between different historical requests, not that we should be able to switch between the request and response.  I 
only show a tree from the response `data`.  I've also noted where I've compacted the tree (powers) and why.  This falls under "nice UI" pragmatism.  

3. I've avoided adding tests, but the app is modular and so should be testable.  Dependency injection (e.g. URLSession or a request factory) could be improved to 
aid with mocking.

4. Due to time constraints I've also avoided CoreData, bindings and a tree controller.  The project was created with CoreData stubs and these have been left in.

5. There are a couple of (noted) places where the code may not be idiomatic Swift.  I tend towards declarative code; I'm of course happy to discuss any decisions, pros 
and cons.

6. Architecturally it's loosely MVVM, without full injection or reactivity, again for pragmatism.  A fully fledged app would have more structure and therefore more care
applied to the implementation of MVVM/reactivity.

7. I've not removed extraneous app menu entries due to being out of scope.

8. Request failure/timeout is not explicitly handled well.

9. There's an intentional delay (`sleep(Int.random()`) in processing the response to better show off the async updates.

10. Standard delegate/datasource extensions do not have method docs.  It's assumed they're standard patterns and well understood.

## Feedback notes

> The idea behind is this task is very simple - to look at two things (the most important to us): architecture and threading. These two things are the most important to us at the moment.
> 
> With that being said, let’s look at your code and what you should have done differently:
> 
> 1. DispatchQueue.global().async - do not use global queues. See here: https://gist.github.com/tclementdev/6af616354912b0347cdf6db159c37057 and here https://developer.apple.com/videos/play/wwdc2017/706/
> 
> 2. Do not expose async code to VCs: 
> 
> 	- Method: MainVC.submitRequest(_:). You should not use queues here at all. Designing your classes in a way, that caller does not know which thread (main or not) will be used for that class is a great idea and all methods must be called from the main thread. So, Data class should have it’s own queue (or one queue per network stuff), API should have its own queue as well.
> 	
> 	The result would be like this:
> 
> 	func submitRequest() {
> 		Data.createSquads(…competion: { 
> 			API.sendRequest(completion: )
> 		}		
> 	}
> 
> 	You see, the great thing about this code is that you can reuse it in other environments (like iOS), you can remove your UI code and have business logic intact.
> 	
> I know you might get to the point where you will have a lot of completion handlers, but you can solve this problem with coroutines or promises or NSOperationQueue if you do not want to depend on the 3rd party stuff.
> 
> As a user of your API, I should not think about which queue that thing is running. As a designer of API, you won’t have to think about ways user used your API.
