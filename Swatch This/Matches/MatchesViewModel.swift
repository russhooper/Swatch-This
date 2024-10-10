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
    
    @Published private(set) var userActiveMatches: [Match] = []
    @Published private(set) var userCompletedMatches: [Match] = []

    @Published private(set) var match: [Match] = []

    
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForActiveMatches() {
        
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        
        MatchesManager.shared.addListenerForMatches(userID: authDataResult.uid, isCompleted: false)
            .sink { completion in
                
            } receiveValue: { [weak self] activeMatches in
                guard let self = self else { return }
                
                self.userActiveMatches = activeMatches
                
                /*
                Task {
                    // Iterate over each match and update asynchronously
                    for (index, match) in activeMatches.enumerated() {
                        do {
                            // retrieve Match so that we can determine if the local user can take their turn
                            let match = try await MatchesManager.shared.getMatch(matchID: userMatch.id)
                            
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
                 */
            }
            .store(in: &cancellables)
    }
    
  
    func addListenerForCompletedMatches() {
        
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        
        MatchesManager.shared.addListenerForMatches(userID: authDataResult.uid, isCompleted: true)
            .sink { completion in
                
            } receiveValue: { [weak self] completedMatches in
                self?.userCompletedMatches = completedMatches
            }
            .store(in: &cancellables)
    }
    
    func removeListenerForCompletedMatches() {
        
        MatchesManager.shared.removeListenerForCompletedMatches()
        
    }
    

    /*
    func getMatches() {
        Task {
            
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            
            print("authDataResult: \(authDataResult)")
            
            
            self.userActiveMatches = try await MatchesManager.shared.getAllMatches(forUser: authDataResult.uid)
            
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
    */
    
    
}



func getMatchesCount() {
    Task {
        let count = try await MatchesManager.shared.getAllMatchesCount()
        print("All match count: \(count)")
    }
}
