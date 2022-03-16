//
//  PusherExtensions.swift
//  ChannelsTest1
//
//  Created by Robin Macharg on 23/06/2020.
//  Copyright © 2020 Robin Macharg. All rights reserved.
//

import Foundation
import PusherSwift

public enum PusherChannelType {
    case publicChannel
    case privateChannel
    // ...
}

extension Pusher {
    
    /**
     * A convenience function to modify the channel name for a strongly typed channel type
     *
     * param docs etc here...
     */
    open func subscribe(
        _ channelName: String,
        channelType: PusherChannelType = .publicChannel,
        auth: PusherAuth? = nil,
        onMemberAdded: ((PusherPresenceChannelMember) -> ())? = nil,
        onMemberRemoved: ((PusherPresenceChannelMember) -> ())? = nil
    ) -> PusherChannel {
    
        var finalChannelName = channelName
        switch channelType {
        case .privateChannel:
            finalChannelName = "private-\(channelName)"
        default:
            break
        }
        
        return self.subscribe(finalChannelName,
                              auth: auth,
                              onMemberAdded: onMemberAdded,
                              onMemberRemoved: onMemberRemoved)
    }
}
