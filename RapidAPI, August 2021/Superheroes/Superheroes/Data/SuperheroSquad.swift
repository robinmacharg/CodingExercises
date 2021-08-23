//
//  SuperheroSquad.swift
//  Superheroes
//
//  Created by Robin Macharg on 27/07/2021.
//
// Codable representations of squads of superheroes

import Foundation

// MARK: - SuperheroSquad
struct SuperheroSquad: Codable, Equatable {
    let id: String
    let squadName: String
    let homeTown: String
    let formed: Int
    let active: Bool
    var members: [Member]

    init(
        size: Int,
        squadName: String,
        homeTown: String,
        formed: Int,
        active: Bool,
        members: [Member])
    {
        self.id = UUID().uuidString
        self.squadName = squadName
        self.homeTown = homeTown
        self.formed = formed
        self.active = active
        self.members = members
    }
}

typealias Powers = [String]

// MARK: - Member
struct Member: Codable, Equatable {
    let name: String
    let age: Int
    let secretIdentity: String
    let powers: Powers
}
