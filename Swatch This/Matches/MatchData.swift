//
//  MatchData.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/15/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation

// MatchData is the local and persistent (during runtime) expanded version of Match, which is what's actually put into Firebase.

class MatchData {   // should this be a struct?
    
    static let shared = MatchData() // Singleton instance
    
    // should make some of these optional
    
    var turnArray: [Int]
    var localPlayerID: String?
    var players: [String: Int]? // dictionary of player, score
    var sortedPlayersArray: [String]?
    var finalPointsArray: [Int]?
    var submissionsByPlayer: [String: String]?
    var currentPlayer: Int?     // this keeps track of whose turn it currently is
    var onlineGame: Bool?
    
    var match: Match // contains id, matchID, matchPassword?, playerIDs, colorIndices, createdNames?, guessedNames?, appVersion?, dateCreated?, phase?, playerDisplayNames?
    
    // should this still be done? Maybe just used for local match?
    private init() { // initialize with defaults
        
        self.turnArray = [0, 0]    // turn, roundsFinished
        
      //  self.localPlayerID = nil
        
        /*
        self.colors = [
            Round(colorIndex: 0)
        ]
        
        
        // dictionary of player, score
        self.players = [
            "Player 1": 0,
            "Player 2": 0
        ]   // will have at least 2 players
        
        
        self.sortedPlayersArray = [
            "Player 1",
            "Player 2"
        ]
        
        self.displayNames = [
            "Player 1": "Player 1",
            "Player 2": "Player 2"
        ]
        
        self.finalPointsArray = [
            1,
            1
        ]
        
        self.submissionsByPlayer = [
            "Submitted color" : "Player X"
        ]
         
         self.appVersion = 1.0

        */
        self.currentPlayer = 1
                        
        self.onlineGame = false
                
        
        self.match = Match(id: "matchID1",
                           matchID: "matchID1",
                           matchPassword: nil,
                           playerIDs: ["playerID1"],
                           colorIndices: [0,0,0,0],
                           createdNames: nil,
                           guessedNames: nil,
                           appVersion: nil,
                           dateCreated: Date(),
                           turnLastTakenDate: nil,
                           phase: nil,
                           phaseByPlayer: nil,
                           playerDisplayNames: nil,
                           playerCount: 2,
                           isCompleted: false)
        
    }
    
    /*
    func getCreatedNames(for userID: String) -> [String] {
        return match.colors.compactMap { round in
            round.createdNames?[userID]
        }
    }
    */
}
