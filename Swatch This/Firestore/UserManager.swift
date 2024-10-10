//
//  UserManager.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine


class LocalUser: Codable {
    static var shared = LocalUser() // Singleton instance

    var userID: String
    var isAnonymous: Bool?
    var email: String?
    var displayName: String?
    var photoURL: String?
    var dateCreated: Date?
    var isPremium: Bool?
    
    private init() { // initialize with defaults
        self.userID = "user1"
        self.isAnonymous = nil
        self.email = nil
        self.displayName = nil
        self.photoURL = nil
        self.dateCreated = nil
        self.isPremium = nil
    }
    
    
    /*
    
    // if we're creating a user, we can set a number of these things from the auth data
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.displayName = auth.displayName
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
    }
    
    // sometimes we do need to initialize the user not from authentication
    init(
        userID: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        displayName: String? = nil,
        photoURL: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil
    ) {
        self.userID = userID
        self.isAnonymous = isAnonymous
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
    }
     
     */
    
}




final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("Users")

    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
   
    
 
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        LocalUser.shared = try await getUser(userID: authDataResult.uid)
    }
        

        
    func createNewUser(user: LocalUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    
    func getUser(userID: String) async throws -> LocalUser {
        print("userID: \(userID)")
        return try await userDocument(userID: userID).getDocument(as: LocalUser.self)
    }
    

    
    
    func updateUserPremiumStatus(userID: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            "isPremium": isPremium
        ]
        
        try await userDocument(userID: userID).updateData(data)
    }
    
    func getUserDisplayName() async throws -> String? {
        
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return nil }
        
        let user = try await userDocument(userID: authDataResult.uid).getDocument(as: LocalUser.self)
        
        return user.displayName
    }
    
    func updateUserDisplayName(displayName: String) async throws {
                
        guard let authDataResult = try? AuthenticationManager.shared
            .getAuthenticatedUser() else { return }
        
        let data: [String:Any] = [
            "displayName": displayName
        ]
        
        try await userDocument(userID: authDataResult.uid).updateData(data)
    }
    
}


