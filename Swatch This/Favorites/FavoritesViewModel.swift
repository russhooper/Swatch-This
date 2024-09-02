//
//  FavoritesViewModel.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import Combine


@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published private(set) var userFavoriteProducts: [UserFavoriteProduct] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForFavorites() {
        
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        /*
         UserManager.shared.addListenerForAllUserFavoriteProducts(userID: authDataResult.uid) { [weak self] products in
         self?.userFavoriteProducts = products
         // "self." makes this a "strong reference." products is returned at a later point than the call, so there's a chance that this class would be deallocated. The strong reference prevents that deallocation.
         
         // ["[weak self]" allows self to be optional (denoted by "?"), meaning that if the completion handler gets called here but self is deallocated, then we just get a nil result that we ignore
         }
         */
        
        UserManager.shared.addListenerForAllUserFavoriteProducts(userID: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] products in
                self?.userFavoriteProducts = products
            }
            .store(in: &cancellables)
        
        
    }
    
    /* // no longer used; superseded by addListenerForFavorites()
     func getFavorites() {
     Task {
     
     let authDataResult = try AuthenticationManager.shared
     .getAuthenticatedUser()
     // Maybe not ideal to be making this request in every view model.
     // It could be better to pass the user ID into the view models when they init, or store it in a user default.
     // However, this is fetching from the local FireBase SDK, not hitting the server (which we know because it's not an await request), so maybe not actually bad.
     // Plus, we'd know immediately if a user logs out
     
     //   print("authDataResult: \(authDataResult)")
     
     
     self.userFavoriteProducts = try await UserManager.shared.getAllUserFavoriteProducts(userID: authDataResult.uid)
     
     //   print("userFavoriteProducts: \(userFavoriteProducts)")
     
     }
     }
     */
    
    func removeFromFavorites(favoriteProductID: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserFavoriteProduct(userID: authDataResult.uid, favoriteProductID: favoriteProductID)
        }
    }
}
