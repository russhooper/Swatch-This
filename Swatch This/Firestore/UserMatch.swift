//
//  UserMatch.swift
//  Swatch This
//
//  Created by Russ Hooper on 10/3/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation


// the UserMatch is a list of match IDs that the user is or was part of
// these are all case sensitive
struct UserMatch: Identifiable, Codable, Equatable {
    let id: String
    let matchID: String
    var isCompleted: Bool
    let match: Match
    var turnLastTakenDate: Date? // need this here in addition to Match because Firebase can only query on top-level info
    var canTakeTurn: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchID
        case isCompleted
        case match
        case turnLastTakenDate
        case canTakeTurn
    }
    
    static func ==(lhs: UserMatch, rhs: UserMatch) -> Bool {
        return lhs.id == rhs.id
    }
}
