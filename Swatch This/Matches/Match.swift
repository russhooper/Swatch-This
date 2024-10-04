//
//  Match.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation


// this is what's put in the Firebase Matches collection

// these are all case sensitive
struct Match: Identifiable, Codable, Equatable {
    let id: String // need id for Identifiable
    
    let matchID: String
    let matchPassword: String?
    let playerIDs: [String]
    
    var colorIndices: [Int]
    var createdNames: [[String: String]]? // userid, color name
    var guessedNames: [[String: String]]? // userid, color name
    
    let appVersion: Double?
    
  //  let colorIndices: [Int]?
    
    let dateCreated: Date
    var turnLastTakenDate: Date?
    var phase: Int? // 1 for name creation phase, 2 for guessing phase, 3 for complete
    var phaseByPlayer: [String: Int]?
    var playerDisplayNames: [String: String]? // optional dictionary of player display names keyed to player IDs
    let playerCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchID
        case matchPassword
        case playerIDs
        case colorIndices
        case createdNames
        case guessedNames
        case appVersion
        case dateCreated
        case turnLastTakenDate
        case phase
        case phaseByPlayer
        case playerDisplayNames
        case playerCount
    }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
}



