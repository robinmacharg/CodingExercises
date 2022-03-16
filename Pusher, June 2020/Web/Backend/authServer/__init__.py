"""
A simple Flask server to authenticate Pusher Client requests.

Written as preparation for a second round Pusher interview.
Rough and ready.  YMMV.

Robin Macharg, robin.macharg@gmail.com

Assumptions:

    >2020, and at least 2m separation: You <------------- 2m -------------> Me
    MacOS 10.15
    Xcode 11.5
    (Default) Python 2.7 (deprecated, I know, but still...)
    iOS 13.x (simulator or real device, either works)
    (Current) Chrome

Run this by doing the following:

- Create and enable a virtual environment:

        mkdir authServer
        cd authServer
        sudo python2 -m pip install virtualenv
        python2 -m virtualenv venv
        . venv/bin/activate
        cd ..
    
- Install Flask and Pusher in the venv:

        pip install Flask Pusher
    
- Run the server:

        FLASK_APP=authServer FLASK_ENV=development flask run

- Test the server with a synthesized request:

        curl -X POST \
             --form "channel_name=foo" \
             --form "socket_id=123456.123456" \
             http://127.0.0.1:5000/pusher/auth
      
  You should see something like the following response:
  
        {"auth": "7e01c26517a8917dfd01:ec82e61acca9971bba23486d05e2703a4a4263cd5943b047fce21413687ae695"}
  
- Install cocoapods:

        pod install
        
- Open the Worspace in XCode

- Start the iOS app.

- Run the test Web/Frontend/index.html and type something into the text box.
  Observe the iOS app noticing the typing.
  
"""

import os
from flask import Flask, request, Response
import pusher
import json

def create_app(test_config=None):

    # ---------------------------------------------------------------
    # Setup
    # ---------------------------------------------------------------

    pusher_client = pusher.Pusher(
        app_id='1023609',
        key='7e01c26517a8917dfd01',
        secret='002a25021101aa654f39',
        cluster='eu',
        ssl=True
    )
    
    app = Flask(__name__, instance_relative_config=True)

    # ---------------------------------------------------------------
    # /pusher/auth
    # ---------------------------------------------------------------

    @app.route("/pusher/auth", methods=['POST'])
    def pusher_authentication():

        auth = pusher_client.authenticate(
            channel=request.form['channel_name'],
            socket_id=request.form['socket_id']
        )
        
        response = Response(json.dumps(auth))
        response.headers['Access-Control-Allow-Origin'] = '*'
        
        return response

    return app
