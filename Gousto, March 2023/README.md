# Gousto supervised coding exercise

This folder contains the final code generated during a supervised coding
exercise for Gousto. The originally provided code is contained in the zip file
in this directory. Around 45 minutes was allotted for the exercise.

The app initially presented a single Welcome screen with a timer and a
non-functional button.

The task proposed was adding a second screen, opened by tapping the button, that
would display a list of food and drink items, along with associated image. This
required the following additions:

-  Addition of an async-based network service (`APIService`)that would request and parse a
   JSON response from a provided endpoint.  Since the endpoint is not guaranteed
   to persist in time a static copy of the response can be found in
   [`sampleResponse.json`](sampleResponse.json).  The network code showcases a Generic handler that takes arbitrary Codable request and response types with configurable response status handling.
- Modification of the provided `Product` model to conform to the actual data.  The `images` subkey was missing, and was noted to be arbitrarily-keyed (i.e. could be any width-representing string).  Based on the provided sample data it was noted that the field always existed, but that it could be empty-valued.
- The creation of the second screen.  This was done as a
  `UIHostingController`-wrapped SwiftUI View (`ProductListView`).  Gousto are
  transitioning to a mixed UIKit/SwiftUI app and so this was - with discussion -
  deemed a good way of showcasing how to integrate SwiftUI in a predominantly
  UIKit-based app.  The list view is a simple `ScrollView`-wrapped `LazyVStack` containing text and an `AsyncImage`.  There was no existing explicit navigation management.  For the purposes of this exercise a simple `self.show(hostingController)` (in `DashboardViewController`) was deemed sufficient.

Due to the time constraints several compromises are noted:

- There is no additional testing
- There is no significant commenting; code formatting has not been rigorous due
  to the ongoing discussions and time restrictions. 
- The width-keyed image model would, in production, be queried for the nearest size that matched.  Here it's hardcoded to the provided 750 pixels.

[Postman](https://www.postman.com/) was used for the initial remote query to
  validate the endpoint and understand the response.  The equivalent
  `jq`-formatted `cURL` would be:

  ```sh
  curl --location --request GET 'https://api.gousto.co.uk/products/v2.0/products?image_sizes%5B%5D=750' | jq .
  ```

A pre-existing logging class was copied in but it's ackknowledged that `print()`
would have sufficed in this case.