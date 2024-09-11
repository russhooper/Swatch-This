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
    
    private let matchesCollection = Firestore.firestore().collection("Matches")
    
    private func matchDocument(matchID: String) -> DocumentReference {
        matchesCollection.document(matchID)
    }
    
    func getMatch(matchID: String) async throws -> Match {
        try await matchDocument(matchID: matchID).getDocument(as: Match.self)
    }
    
    private func getAllMatchesQuery() -> Query {
        matchesCollection
    }
    
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
