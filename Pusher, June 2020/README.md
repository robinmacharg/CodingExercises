#  Pusher demo

Written by Robin Macharg, 06/2020

This directory contains simple demonstrations of using Pusher's websockets library to:

- Send an event from the command-line to an iOS app.
- Authenticate web and iOS clients and create a private channel  
- Send events from a web page (via JS) to the iOS app

Assuming Cocoapods is installed:

- In a terminal change to the top-level directory containing this README
- run `pod install`
- Open the `.workspace` in XCode
- Add a breakpoint in `ViewController.swift` in the `my-event` callback (~line 52)
- Run the app (in the simulator or on a real device)
- Again in the terminal, run `python Web/Backend/sendEvent.py`
- The app will pause on the breakpoint (proving a simple event send from the "server")
- Remove the breakpoint
- In the terminal change to the `Web/Backend`cdirectory, enter the venv: `. venv/bin/activate`, 
- Run the authentication Flask server: `FLASK_APP=authServer FLASK_ENV=development flask run`
- In Finder, double click the `Web/Frontend/index.html` file to open a webpage in a browser
- Ensure the App is visible and type a few characters in the text box.
- The App will show a "Typing..." status.  
- Wait a few seconds after stopping typing and the status text will disappear (proving that private client communication works)

