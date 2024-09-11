//
//  GameData.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/17/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
//import Combine

final class GameData: ObservableObject, Codable {
    
    var turnArray = [0, 0]    // turn, roundsFinished
    
    
    var colorIndices: [Int] = [
        0,
        0,
        0,
        0
    ]
    
    // we can manually set this up since we know there will be 4 color entry arrays
    var submittedColorNames = [
        ["Placeholder"],
        ["Placeholder"],
        ["Placeholder"],
        ["Placeholder"]
    ]
    
    
    // dictionary of player, score
    var players = [
        "Player 1": 0,
        "Player 2": 0
    ]   // will have at least 2 players
    
    
    var sortedPlayersArray = [
        "Player 1",
        "Player 2"
    ]
    
    var displayNames = [
        "Player 1": "Player 1",
        "Player 2": "Player 2"
    ]
    
    
    var finalPointsArray = [
        1,
        1
    ]
    
    var submissionsByPlayer = [
        "Submitted color" : "Player X"
    ]
    
    // array (rounds) of arrays (players) of dictionaries (created name, guessed name)
    var playersByRound = [

        // round 0
        [
            ["Created": "Submitted color", "Guessed": "Guessed color" ],    // player 1
            ["Created": "Submitted color", "Guessed": "Guessed color" ],    // player 2
        ],
        
        // round 1
        [
            ["Created": "Submitted color", "Guessed": "Guessed color" ],
            ["Created": "Submitted color", "Guessed": "Guessed color" ]
        ],
        
        // round 2
        [
            ["Created": "Submitted color", "Guessed": "Guessed color" ],
            ["Created": "Submitted color", "Guessed": "Guessed color" ]
        ],
        
        // round 3
        [
            ["Created": "Submitted color", "Guessed": "Guessed color" ],
            ["Created": "Submitted color", "Guessed": "Guessed color" ]
        ]
    ]
    
    
    // this keeps track of whose turn it currently is
    var currentPlayer = 1
    
    var isComplete = false
    
    var matchID = "abc123"
    
    var onlineGame = false
        
    var matchDate: Date = Date() // will be set to the date when the match was finished
    
    var appVersion: Float = 1.0 // will be set to the app version when the match was created
    
}
