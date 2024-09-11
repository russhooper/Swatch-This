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
    
    
    func removeFromFavorites(favoriteProductID: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userID: authDataResult.uid, favoriteProductID: favoriteProductID)
        }
    }
    
    
    
    // superseded by addListenerForFavorites()
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
