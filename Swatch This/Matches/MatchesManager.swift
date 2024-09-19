//
//  MatchesManager.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import FirebaseFirestore

final class MatchesManager {
    
    static let shared = MatchesManager()
    private init() { }
    
    var gameData: GameData = GameData()
    
    private let matchesCollection = Firestore.firestore().collection("Matches")
    
    private func matchDocument(id: String) -> DocumentReference {
        let docRef = matchesCollection.document(id)
        print("docRef: \(docRef)")
        return docRef
    }
    
    func getMatch(matchID: String) async throws -> Match {
        try await matchDocument(id: matchID).getDocument(as: Match.self)
    }
    
    private func getAllMatchesQuery() -> Query {
        matchesCollection
    }
    
    
    func createMatch() { // should differentiate between online and local and not upload online at this point
        
        let indiciesCount = 4 //

        MatchData.shared.colorIndices = GameBrain().generateNIndices(count: indiciesCount)
        MatchData.shared.onlineGame = true

        
        let rounds: [Round] = MatchData.shared.colorIndices.map { index in
            Round(colorIndex: index, createdNames: nil, guessedNames: nil)
        }
        
        MatchData.shared.colors = rounds
        
        Task {
            do {
                
                guard let authDataResult = try? AuthenticationManager.shared
                    .getAuthenticatedUser() else { return }
                
                MatchData.shared.localPlayerID = authDataResult.uid

                
                
                let matchID = randomString()
                let dateCreated = Date()
                
                let match: Match = await Match(id: matchID,
                                               matchID: matchID, // try to get rid of this bc it's redundant
                                               playerIDs: [authDataResult.uid],
                                               appVersion: Float(UIApplication.appVersion ?? "0"),
                                               colors: rounds,
                                               dateCreated: dateCreated,
                                               phase: 1, // 1 is name creation, 2 is guessing, 3 is complete
                                               playerDisplayNames: ["Joe"])
                
                try? await uploadMatch(match: match)
                
                
                try await self.addMatchToUser(matchID: matchID,
                                              userID: authDataResult.uid,
                                              dateCreated: dateCreated)
                
                
                print("success: \(match.id)")
            } catch {
                print("match creation error: \(error)")
            }
        }
    }
    
    func uploadMatch(match: Match) async throws {
        try matchDocument(id: String(match.id)).setData(from: match, merge: false)
    }
    
    func addMatchToUser(matchID: String, userID: String, dateCreated: Date) async throws {
        
        let userMatch: UserMatch = UserMatch(id: matchID,
                                             matchID: matchID,
                                             isCompleted: false,
                                             dateCreated: dateCreated)
        
        do {
            try await UserManager.shared.createUserMatch(userMatch: userMatch, userID: userID)
        } catch {
            print("UserMatch creation error: \(error)")
        }

    }
    
    
    /*
     func getMatch(matchID: String,
     forPhase phase: Int?,
     lastDocument: DocumentSnapshot?)
     async throws -> (
     matches: [Match],
     lastDocument: DocumentSnapshot?
     ) {
     
     var query: Query = getAllMatchesQuery()
     
     //   UserManager.shared.getUser(userID: <#T##String#>)
     
     query = getAllMatchesForPhaseQuery(phase: phase)
     
     return try await query
     .startOptionally(afterDocument: lastDocument)
     .getDocumentsWithSnapshot(as: Match.self)
     
     }
     */
    private func getAllMatchesForUserQuery(userID: String) -> Query {
        matchesCollection
            .whereField(Match.CodingKeys.playerIDs.rawValue, arrayContains: userID)
    }
    
    private func getAllMatchesForPhaseQuery(phase: Int) -> Query {
        matchesCollection
            .whereField(Match.CodingKeys.phase.rawValue, isEqualTo: 3)
    }
    
    func getAllMatches(forUser userID: String?,
                       forPhase phase: Int?,
                       lastDocument: DocumentSnapshot?)
    async throws -> (
        matches: [Match],
        lastDocument: DocumentSnapshot?
    ) {
        
        var query: Query = getAllMatchesQuery()
        
        //   UserManager.shared.getUser(userID: <#T##String#>)
        
        if let phase {
            query = getAllMatchesForPhaseQuery(phase: phase)
        } else if let userID {
            query = getAllMatchesForUserQuery(userID: userID)
        }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Match.self)
        
    }
    
    func getAllMatchesCount() async throws -> Int {
        try await matchesCollection.aggregateCount()
    }
    
}

