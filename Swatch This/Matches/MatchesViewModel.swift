//
//  MatchesModel.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import Combine


@MainActor
final class MatchesViewModel: ObservableObject {
    
    @Published private(set) var userActiveMatches: [UserMatch] = []
    @Published private(set) var userCompletedMatches: [UserMatch] = []

    @Published private(set) var match: [UserMatch] = []

    
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForActiveMatches() {
        
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        
        UserManager.shared.addListenerForAllUserMatches(userID: authDataResult.uid, isCompleted: false)
            .sink { completion in
                
            } receiveValue: { [weak self] activeMatches in
                guard let self = self else { return }
                
                self.userActiveMatches = activeMatches
                
                Task {
                    // Iterate over each match and update asynchronously
                    for (index, userMatch) in activeMatches.enumerated() {
                        do {
                            // retrieve Match so that we can determine if the local user can take their turn
                            let match = try await MatchesManager.shared.getMatch(matchID: userMatch.matchID)
                            
                            // update the userMatch
                            self.userActiveMatches[index].canTakeTurn = GameBrain().determineGameState(
                                localPlayerID: authDataResult.uid,
                                match: userMatch.match)
                            .canTakeAction
                            
                        } catch {
                            print("Failed to update match details: \(error)")
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /*
    func getMatchStates(userID: String, userMatches: [UserMatch]) async throws -> [UserMatch] {
        
        var updatedUserMatches: [UserMatch] = []
        
        for userMatch in userMatches {
            // modify each match
            var updatedMatch = userMatch
            
            // retrieve Match so that we can determine if the local user can take their turn
            
            let match = try await MatchesManager.shared.getMatch(matchID: userMatch.matchID)
            
            updatedMatch.canTakeTurn = GameBrain().determineGameState(localPlayerID: userID, match: match).canTakeAction
            
            updatedUserMatches.append(updatedMatch)
            
        }
        
        return updatedUserMatches
        
    }
    */
    
    func addListenerForCompletedMatches() {
        
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        
        UserManager.shared.addListenerForAllUserMatches(userID: authDataResult.uid, isCompleted: true)
            .sink { completion in
                
            } receiveValue: { [weak self] completedMatches in
                self?.userCompletedMatches = completedMatches
            }
            .store(in: &cancellables)
    }
    
    func removeListenerForCompletedMatches() {
        
        UserManager.shared.removeListenerForCompletedUserMatches()
        
    }
    

    func getMatchData(userMatch: UserMatch) {
        
        Task {
            do {
                
                let match = try await MatchesManager.shared.getMatch(matchID: userMatch.matchID)
                print(match.matchID)
                                
                MatchData.shared.onlineGame = true

                
                
            } catch {
                print(error)
            }
        }
        
        
    }
    
    
    func getMatches() {
        Task {
            
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            print("authDataResult: \(authDataResult)")
            
            
            self.userActiveMatches = try await UserManager.shared.getAllUserMatches(userID: authDataResult.uid)
            
            print("userActiveMatches: \(userActiveMatches)")
            
        }
    }
    
    func getActiveMatches() {
        Task {
            
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            print("authDataResult: \(authDataResult)")
            
            
            self.userActiveMatches = try await UserManager.shared.getAllUserMatches(userID: authDataResult.uid)
            
            print("userActiveMatches: \(userActiveMatches)")
            
        }
    }
    
    
    
}



func getMatchesCount() {
    Task {
        let count = try await MatchesManager.shared.getAllMatchesCount()
        print("All match count: \(count)")
    }
}
