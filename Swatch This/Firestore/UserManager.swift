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
    
   
    
    private func userMatchesCollection(userID: String) -> CollectionReference {
        let collectionRef = userDocument(userID: userID).collection("UserMatches")
        print("collectionRef: \(collectionRef)")
        return collectionRef
    }
    
    
    private func userMatchDocument(userID: String, matchID: String) -> DocumentReference {
        let matchDoc = userMatchesCollection(userID: userID).document(matchID)
        print("matchDoc: \(matchDoc)")
        return matchDoc
    }
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        LocalUser.shared = try await getUser(userID: authDataResult.uid)
    }
        
    private var userActiveMatchesListener: ListenerRegistration? = nil
    private var userCompletedMatchesListener: ListenerRegistration? = nil

        
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
    
    
    func getAllUserMatches(userID: String) async throws -> [UserMatch] {
        try await userMatchesCollection(userID: userID).getDocuments(as: UserMatch.self)
    }
    
    // add a match as a UserMatches document
    func createUserMatch(userMatch: UserMatch, userID: String) async throws {
        try userMatchDocument(userID: userID, matchID: userMatch.matchID).setData(from: userMatch, merge: false)
    }
    
    func updateUserMatch(userMatch: UserMatch, userID: String) async throws {
        
        let updatedUserMatch = UserMatch(id: userID,
                                         matchID: userMatch.matchID,
                                         isCompleted: true,
                                         dateCreated: userMatch.dateCreated)
        
        // encode the match's colors array using Firestore.Encoder
        guard let encodedData = try? Firestore.Encoder().encode(updatedUserMatch) else {
            print("UserMatch update encoding error")
            throw URLError(.badURL)
        }
        
        let dict: [String: Any] = [
            "isCompleted": encodedData["isCompleted"] ?? []  // properly encoded array of Round objects
        ]
        
        do {
            // update the document with the encoded data
            try await userMatchDocument(userID: userID, matchID: userMatch.matchID).updateData(dict)
        } catch {
            print("UserMatch update error: \(error)")
        }
        
        
    }
    
    func removeListenerForCompletedUserMatches() {
        self.userCompletedMatchesListener?.remove()
    }
    
    func removeListenerForActiveUserMatches() {
        self.userActiveMatchesListener?.remove()
    }


    /*
    private func getAllActiveUserMatches(userID: String) -> Query {
        userMatchesCollection(userID: userID).whereField(UserMatch.CodingKeys.isCompleted.rawValue, isEqualTo: true)
    }
    
    func getAllUserMatches(active isActive: Bool?,
                        lastDocument: DocumentSnapshot?)
    async throws -> (
        matches: [UserMatch],
        lastDocument: DocumentSnapshot?
    ) {
        
        var query: Query = getAllMatchesQuery()
        
        if let isActive {
            query = getAllUserMatches(active: isActive, lastDocument: <#T##DocumentSnapshot?#>)(descending: descending, category: category)
        } else {
            query = getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
        
    }
    */
   
    
        
    func addListenerForAllUserMatches(userID: String, isCompleted: Bool) -> AnyPublisher<[UserMatch], Error> {
                
        let (publisher, listener) = userMatchesCollection(userID: userID)
            .whereField(UserMatch.CodingKeys.isCompleted.rawValue, isEqualTo: isCompleted)
            .order(by: UserMatch.CodingKeys.dateCreated.rawValue, descending: true)
            .addSnapshotListener(as: UserMatch.self)
        
        if  (isCompleted == true) {
            self.userCompletedMatchesListener = listener
        } else {
            self.userActiveMatchesListener = listener
        }
        
        return publisher
    }
    
    
    
}


// the UserMatch is a list of match IDs that the user is or was part of
// these are all case sensitive
struct UserMatch: Identifiable, Codable, Equatable {
    let id: String
    let matchID: String
    var isCompleted: Bool
    let dateCreated: Date

    enum CodingKeys: String, CodingKey {
        case id
        case matchID
        case isCompleted
        case dateCreated
    }
    
    static func ==(lhs: UserMatch, rhs: UserMatch) -> Bool {
        return lhs.id == rhs.id
    }
    
}

