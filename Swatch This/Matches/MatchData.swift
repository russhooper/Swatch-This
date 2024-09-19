//
//  MatchData.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/15/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation

// MatchData is the local and persistent (during runtime) version of Match, which is what's actually put into Firebase.

class MatchData {
    
    static let shared = MatchData() // Singleton instance
    
    var turnArray: [Int]
    var localPlayerID: String
    var colorIndices: [Int]
    var colors: [Round]
    var players: [String : Int] // dictionary of player, score
    var sortedPlayersArray: [String]
    var displayNames: [String : String]
    var finalPointsArray: [Int]
    var submissionsByPlayer: [String : String]
    var currentPlayer: Int     // this keeps track of whose turn it currently is
    var isComplete: Bool
    var matchID: String
    var onlineGame: Bool
    var matchDate: Date // will be set to the date when the match was created
    var appVersion: Float // will be set to the app version when the match was created
    
    
    private init() { // initialize with defaults
        
        self.turnArray = [0, 0]    // turn, roundsFinished
        
        self.localPlayerID = "123"
        
        self.colorIndices = [
            0,
            0,
            0,
            0
        ]
        
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
        
        self.currentPlayer = 1
        
        self.isComplete = false
        
        self.matchID = "abc123"
        
        self.onlineGame = false
        
        self.matchDate = Date()
        
        self.appVersion = 1.0
        
    }
    
}
