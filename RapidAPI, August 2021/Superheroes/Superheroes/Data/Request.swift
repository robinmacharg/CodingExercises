//
//  Request.swift
//  Superheroes
//
//  Created by Robin Macharg2 on 04/08/2021.
//

import Foundation

/**
 * Represents a POST request
 */
class Request {
    class Timestamps {
        var started: Date? = nil
        var completed: Date? = nil

        init(started: Date? = nil, completed: Date? = nil) {
            self.started = started
            self.completed = completed
        }
    }

    var id: UUID
    var timestamps: Timestamps
    var squads: [SuperheroSquad]
    var request: URLRequest
    var returnedData: [SuperheroSquad]? = nil
    var state: RequestState

    init(id: UUID, timestamps: Timestamps, squads: [SuperheroSquad], request: URLRequest, state: RequestState) {
        self.id = id
        self.timestamps = timestamps
        self.squads = squads
        self.request = request
        self.state = state
    }
}
