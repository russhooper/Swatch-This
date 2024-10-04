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
        print("matchDocument ref: \(docRef)")
        return docRef
    }
    
    
    func getMatch(matchID: String) async throws -> Match {
        try await matchDocument(id: matchID).getDocument(as: Match.self)
    }
    
    
    
    private func getAllMatchesQuery() -> Query {
        matchesCollection
    }
    
    
    func joinMatch(match: Match) {
        guard let authDataResult: AuthDataResultModel = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        
        MatchData.shared.localPlayerID = authDataResult.uid
        MatchData.shared.onlineGame = true
        MatchData.shared.match = match
        
        if let playerID = MatchData.shared.localPlayerID {
            if let localDisplayName = LocalUser.shared.displayName {
                if let displayNames = MatchData.shared.match.playerDisplayNames {
                    MatchData.shared.match.playerDisplayNames?[playerID] = localDisplayName
                } else {
                    MatchData.shared.match.playerDisplayNames = [playerID: localDisplayName]
                }
            }
        }

        
    }
    
    func createMatch() { // should differentiate between online and local and not upload online at this point
        
        let indiciesCount = 4 //
        
        MatchData.shared.match.colorIndices = GameBrain().generateNIndices(count: indiciesCount)
        MatchData.shared.onlineGame = true
        
        let playerCount = 2
        
        let matchID = randomString()
        let dateCreated = Date()
        
        let userID = LocalUser.shared.userID
        MatchData.shared.localPlayerID = userID
        
        let phaseByPlayer: [String: Int]? = [userID: 1] // 1 for name creation, 2 for color guessing, 3 for completed
        
        
        var displayNameArray: [String: String]?
        if let authDisplayName = LocalUser.shared.displayName {
            displayNameArray = [userID: authDisplayName]
            
        } else {
            displayNameArray = nil
        }
        
        Task {
            do {
                /*
                guard let authDataResult: AuthDataResultModel = try? AuthenticationManager.shared
                    .getAuthenticatedUser() else { return }
                 let playerID = authDataResult.uid

                */
                

                
                
                
                 
                /*
                if let localDisplayName = LocalUser.shared.displayName {
                    if let displayNames = MatchData.shared.match.playerDisplayNames {
                        displayNameArray[playerID] = localDisplayName
                    } else {
                        displayNameArray = [playerID: localDisplayName]
                    }
                }
                 */
                
                let code = try await generateCode()

                
                print("code: \(String(describing: code))")
                

                
                let match: Match = await Match(id: matchID,
                                               matchID: matchID, // try to get rid of this bc it's redundant
                                               matchPassword: code,
                                               playerIDs: [userID],
                                               colorIndices: MatchData.shared.match.colorIndices,
                                               createdNames: nil,
                                               guessedNames: nil,
                                               appVersion: Double(UIApplication.appVersion ?? "0"),
                                               dateCreated: dateCreated,
                                               turnLastTakenDate: nil,
                                               phase: 1, // 1 is name creation, 2 is guessing, 3 is complete
                                               phaseByPlayer: phaseByPlayer,
                                               playerDisplayNames: displayNameArray,
                                               playerCount: playerCount)
                
                MatchData.shared.match = match
                
                try? await uploadMatch(match: MatchData.shared.match)
                
                
                try await addMatchToUser(match: match,
                                         userID: userID)
                
                
                print("success: \(MatchData.shared.match.id)")
            } catch {
                print("match creation error: \(error)")
            }
        }
    }
    
    func uploadMatch(match: Match) async throws {
        try matchDocument(id: String(match.id)).setData(from: match, merge: false)
    }
    
    
    func addMatchToUser(match: Match, userID: String) async throws {
        
        let userMatch: UserMatch = UserMatch(id: match.matchID,
                                             matchID: match.matchID,
                                             isCompleted: false,
                                             match: match,
                                             turnLastTakenDate: Date())
        
        do {
            try await UserManager.shared.createUserMatch(userMatch: userMatch, userID: userID)
        } catch {
            print("UserMatch creation error: \(error)")
        }
        
    }
    
    func updateMatch(match: Match) async throws {
                        
        // use Firestore.Encoder to encode the Match object
        guard let encodedData = try? Firestore.Encoder().encode(match) else {
              throw URLError(.badURL)
          }
        
        try await matchDocument(id: String(match.matchID)).setData(encodedData, merge: true)
         
        /*
        var match2 = match
        match2.phase = 2
        
        guard let encodedPhase = try? Firestore.Encoder().encode(match2.phase) else {
            print("match update encoding error")
            throw URLError(.badURL)
        }
        
        
        let dict: [String: Any] = [
            "createdNames": encodedData
          //  "phase": encodedPhase
        ]
        
        do {
            // update the document with the encoded data
            try await matchDocument(id: String(match.matchID)).updateData(dict)
        } catch {
            print("match update error: \(error)")
        }
        */
        
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
    
    private func generateCode() async throws -> String? {
        
        if let code = try await MatchCodeManager().getRandomCode() {
            return code
        } else {
            // if the color name codes fails for some reason, generate a random code
            let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
            return String((0..<6).map { _ in characters.randomElement()! })
        }
        
    }
    
    func checkMatchCode(password: String) async throws -> [Match]? {
        
        let query = getAllMatchesForCode(password: password)
        
        let (matches, _) = try await query
            .getDocumentsWithSnapshot(as: Match.self)
        // This function returns a tuple. (matches, _) will get the first object of the tuple
        
      //  return !matches.isEmpty
        if matches.count > 0 {
            return matches
        } else {
            return nil
        }
    }
    
    
    
    private func getAllMatchesForCode(password: String) -> Query {
        matchesCollection
            .whereField(Match.CodingKeys.matchPassword.rawValue, isEqualTo: password)
    }
    
    
    private func getAllMatchesForUserQuery(userID: String) -> Query {
        matchesCollection
            .whereField(Match.CodingKeys.playerIDs.rawValue, arrayContains: userID)
    }
    
    private func getAllMatchesForPhaseQuery(phase: Int) -> Query {
        matchesCollection
            .whereField(Match.CodingKeys.phase.rawValue, isEqualTo: phase)
    }
    
    func getAllMatches(forUser userID: String?,
                       forPhase phase: Int?,
                       lastDocument: DocumentSnapshot?)
    async throws -> (
        matches: [Match],
        lastDocument: DocumentSnapshot?
    ) {
                        
        if let phase {
            let query = getAllMatchesForPhaseQuery(phase: phase)
            
            return try await query
                .startOptionally(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Match.self)
            
        } else if let userID {
            let query = getAllMatchesForUserQuery(userID: userID)
            
            return try await query
                .startOptionally(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Match.self)
            
        } else {
            let query = getAllMatchesQuery()
            
            return try await query
                .startOptionally(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Match.self)
        }
        
        
    }
    
    func getAllMatchesCount() async throws -> Int {
        try await matchesCollection.aggregateCount()
    }
    
}

