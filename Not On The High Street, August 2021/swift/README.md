# Gilded Rose (Swift)

## Running Swift

To build and run:

    git clone https://github.com/notonthehighstreet/gilded-rose.git
    cd gilded-rose/swift/
    swift run
    
To adjust number of days:

    swift run GildedRoseApp 5
    
<sup>Replace 5 with your value</sup>

To build and run tests:

    swift test

### Install Swift

https://swift.org/getting-started/#installing-swift

## Using Xcode

You can open the `Package.swift` file in Xcode to build and run the project if you prefer. When running the application from Xcode it will default to printing the first 2 days in the console. To adjust this add an Integer environmental variable to the `GildedRose` build scheme:

<img width="773" alt="Screenshot 2021-05-21 at 11 05 33" src="https://user-images.githubusercontent.com/630601/119180032-9fc7c780-ba67-11eb-849c-78e0bf691fd9.png">
