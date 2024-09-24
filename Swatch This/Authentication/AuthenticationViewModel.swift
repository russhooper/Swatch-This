//
//  AuthenticationViewModel.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await signIn(authDataResult: authDataResult)

    }
    
    // all part of one async flow, so it won't get to the end of this until it successfully runs all lines
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        try await signIn(authDataResult: authDataResult)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        try await signIn(authDataResult: authDataResult)
    }
    
    func signIn(authDataResult: AuthDataResultModel) async throws {
        
        DBUser.shared.userID = authDataResult.uid
        DBUser.shared.isAnonymous = authDataResult.isAnonymous
        DBUser.shared.email = authDataResult.email
        DBUser.shared.displayName = authDataResult.displayName
        DBUser.shared.photoURL = authDataResult.photoURL
        DBUser.shared.dateCreated = Date()
                
        try await UserManager.shared.createNewUser(user: DBUser.shared)
    }
    
    
}

