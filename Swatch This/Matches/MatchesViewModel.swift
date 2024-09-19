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
                self?.userActiveMatches = activeMatches
                // ["[weak self]" allows self to be optional (denoted by "?"), meaning that if the completion handler gets called here but self is deallocated, then we just get a nil result that we ignore
                
            }
            .store(in: &cancellables)
    }
    
    
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
                
                MatchData.shared.colorIndices = match.colors.map {  round in
                    return round.colorIndex
                } // Use map to extract colorIndex from each Round in the colors array
                
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
