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
        
        LocalUser.shared.userID = authDataResult.uid
        LocalUser.shared.isAnonymous = authDataResult.isAnonymous
        LocalUser.shared.email = authDataResult.email
        LocalUser.shared.displayName = authDataResult.displayName
        LocalUser.shared.photoURL = authDataResult.photoURL
        LocalUser.shared.dateCreated = Date()
                
        try await UserManager.shared.createNewUser(user: LocalUser.shared)
    }
    
    
}

