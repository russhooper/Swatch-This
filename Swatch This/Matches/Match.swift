//
//  Match.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation


// these are all case sensitive
struct Match: Identifiable, Codable, Equatable {
    let id: String // need id for Identifiable
    
    let matchID: String
    let playerIDs: [String]
    
    let appVersion: Float?

    // array (round) of dictionaries: colorIndex (int), createdNames (array of strings), guessed names (array of strings)
    var colors: [Round] // Array of Round structs, which contain the data for each match round
        
        
    
  //  let colorIndices: [Int]?
    
    let dateCreated: Date?
    let phase: Int? // 1 for name creation phase, 2 for guessing phase, 3 for complete
    let playerDisplayNames: [String?]? // optional strings in an optional array
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case matchID
        case playerIDs
        case appVersion
        case colors
     //   case colorIndices
        case dateCreated
        case phase
        case playerDisplayNames
    }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
}


struct Round: Codable, Equatable {
    var colorIndex: Int
    var createdNames: [String?]?
    var guessedNames: [String?]?
}
