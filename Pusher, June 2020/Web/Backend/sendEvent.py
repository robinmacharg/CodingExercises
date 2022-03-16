#!/usr/bin/python

"""
Example cmd-line app to send an event to an iOS Pusher client

See the README.md for details...
"""

import pusher

pusher_client = pusher.Pusher(
  app_id='1023609',
  key='7e01c26517a8917dfd01',
  secret='002a25021101aa654f39',
  cluster='eu',
  ssl=True
)

pusher_client.trigger('my-channel', 'my-event', {'message': 'hello world'})

