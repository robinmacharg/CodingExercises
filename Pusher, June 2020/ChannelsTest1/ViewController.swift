//
//  ViewController.swift
//  ChannelsTest1
//
//  Created by Robin Macharg on 22/06/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//
// TODO: Replace with a standard corporate copyright header
//       Explain what this VC does in the broadest sense.  Lead the dev in by answering the "why?"

import UIKit
import PusherSwift

/**
 * The main ViewController
 */
class ViewController: UIViewController, PusherDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Instance variables
    
    var pusher: Pusher!
    private var members: [String : PusherPresenceChannelMember] = [:]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
        tableView.dataSource = self
        tableView.delegate = self
        configurePusher()
    }

    // MARK: - Helpers
    
    /**
     * Configure Pusher websocket notifications.
     * The aim is to show "<USER> is typing..." messages (and hide them).  Anything else is a bonus.
     * This would typically be decoupled from a specific VC, but proves the point.
     * Contains code for receiving both public and private messages.
     * Not all code paths are useful.
     */
    private func configurePusher() {
        let options = PusherClientOptions(
//            authMethod: .endpoint(authEndpoint: "http://127.0.0.1:5000/pusher/auth"),
            authMethod: .endpoint(authEndpoint: "https://ios-interview-auth-endpoint.herokuapp.com/pusher/auth"),
            host: .cluster("eu")
        )

        pusher = Pusher(
          key: "7e01c26517a8917dfd01",
          options: options
        )

        pusher.delegate = self

        // public channel
        let publicChannel = pusher.subscribe("my-channel")
        
        // private channel - Note: uses a convenience extension
        let privateChannel = pusher.subscribe("my-channel", channelType: .privateChannel)

        // bind a callback to handle an event
        let _ = publicChannel.bind(eventName: "my-event", eventCallback: { (event: PusherEvent) in
            if let data = event.data {
              print(data)
            }
        })
        
        // Here's the meat.  Typing in the web form should show up in the app UI.
        
        // Hardcoded handler.  We expect the message to be a specific one
        let _ = privateChannel.bind(eventName: "client-my-event") { (event: PusherEvent) in
            self.updateStatus(event: event)
        }

        // MARK: - Presence
        
        let onMemberAdd = { (member: PusherPresenceChannelMember) in
            self.members[member.userId] = member
            self.tableView.reloadData()
        }

        let onMemberRemove = { (member: PusherPresenceChannelMember) -> () in
            self.members.removeValue(forKey: member.userId)
            self.tableView.reloadData()
        }
        
        let myPresenceChannel = pusher.subscribeToPresenceChannel(
            channelName: "presence-my-channel",
            onMemberAdded: onMemberAdd,
            onMemberRemoved: onMemberRemove)
        
        myPresenceChannel.bind(eventName: "pusher:subscription_succeeded", eventCallback: { event in
            print("Subscribed!")
            print("I can now access myId: \(myPresenceChannel.myId!)")
            print("And here are the channel members: \(myPresenceChannel.members)")
            for member in myPresenceChannel.members {
                self.members[member.userId] = member
            }
            self.tableView.reloadData()
        })
        
        pusher.connect()
    }

    /**
     * Update the status message
     *
     * - parameter event: The Pusher Channels event.  We do minimal validation.
     */
    private func updateStatus(event: PusherEvent) {
        // By default we clear the status
        var text = ""
        if let data = event.data?.data(using: .utf8) {
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any], object["typing"] as? Bool ?? false {
                text = "\(object["user"] as? String ?? "Someone") is typing..."
                // Ideally we'd start a timer and auto-disable the message if we've not heard
                // from the client in N seconds to avoid a stuck message.  Details, details...
            }
        }
        
        self.statusLabel.text = text
    }
    
    // MARK: - Actions
    
    // Reciprocal client event sending
    // TBD...
    @IBAction func sendEvent(_ sender: Any) {}
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as? MemberCell else {
            fatalError("The dequeued cell is not an instance of cell.")
        }

//        members.keys.sorted()[indexPath.row]
//        var member = members[indexPath.row]
        cell.memberName!.text = members.keys.sorted()[indexPath.row]
        return cell
    }
}

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var memberName: UILabel!
}
