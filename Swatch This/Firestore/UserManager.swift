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

struct Movie: Codable {  // we'll store this movie struct within DBUser > Preferences
    let id: String
    let title: String
    let isPopular: Bool
}

struct DBUser: Codable {
    let userID: String
    let isAnonymous: Bool?
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    let isPremium: Bool?
    let preferences: [String]?
    let favoriteMovie: Movie?
    
    // if we're creating a user, we can set a number of these things from the auth data
    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoURL = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
        self.preferences = nil
        self.favoriteMovie = nil
    }
    
    // sometimes we do need to initialize the user not from authentication
    init(
        userID: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoURL: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil,
        preferences: [String]? = nil,
        favoriteMovie: Movie? = nil
    ) {
        self.userID = userID
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.preferences = preferences
        self.favoriteMovie = favoriteMovie
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("Users")

    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    private func userFavoriteProductCollection(userID: String) -> CollectionReference {
        let collectionRef = userDocument(userID: userID).collection("favoriteProducts")
      //  print("collectionRef: \(collectionRef)")
        return collectionRef
    }
    
    private func userMatchesCollection(userID: String) -> CollectionReference {
        let collectionRef = userDocument(userID: userID).collection("UserMatches")
        print("collectionRef: \(collectionRef)")
        return collectionRef
    }
    
    private func userFavoriteProductDocument(userID: String, favoriteProductID: String) -> DocumentReference {
        let favDoc = userFavoriteProductCollection(userID: userID).document(favoriteProductID)
      //  print("favDoc: \(favDoc)")
        return favDoc
    }
    
    private func userMatchDocument(userID: String, matchID: String) -> DocumentReference {
        let matchDoc = userMatchesCollection(userID: userID).document(matchID)
        print("matchDoc: \(matchDoc)")
        return matchDoc
    }
    
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    private var userMatchesListener: ListenerRegistration? = nil

    
    
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    
    func getUser(userID: String) async throws -> DBUser {
        print("userID: \(userID)")
        return try await userDocument(userID: userID).getDocument(as: DBUser.self)
    }
    
    
    func updateUserPremiumStatus(userID: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            "isPremium": isPremium
        ]
        
        try await userDocument(userID: userID).updateData(data)
    }
    
    
    
    ////
    
    func addUserPreference(userID: String, preference: String) async throws {
        let data: [String:Any] = [
            "preferences": FieldValue.arrayUnion([preference]) // append new preference onto existing Firebase array
        ]
        
        try await userDocument(userID: userID).updateData(data)
    }
    
    func removeUserPreference(userID: String, preference: String) async throws {
        let data: [String:Any] = [
            "preferences": FieldValue.arrayRemove([preference]) // remove passed in preference from existing Firebase array
        ]
        
        try await userDocument(userID: userID).updateData(data)
    }
    
    func addFavoriteMovie(userID: String, movie: Movie) async throws {
        
        guard let data = try? Firestore.Encoder().encode(movie) else {
            throw URLError(.badURL)
        }
        
        let dict: [String:Any] = [
            "movie": data
        ]
        
        try await userDocument(userID: userID).updateData(dict)
    }
    
    func removeFavoriteMovie(userID: String) async throws {
        
        let data: [String:Any?] = [
            "movie": nil // remove movie
        ]
        
        try await userDocument(userID: userID).updateData(data as [AnyHashable: Any])
    }
    
    func addUserFavoriteProduct(userID: String, productID: Int) async throws {
        let document = userFavoriteProductCollection(userID: userID).document()
        print("document: \(document)")
        let documentID = document.documentID
        print("documentID: \(documentID)")

        let data: [String:Any] = [
            "id" : documentID,
            "productID" : productID,
            "dateCreated" : Timestamp()
        ]
        
        try await document.setData(data, merge: false)
        // .document() gives the document's auto-generated ID
    }
    
    func removeUserFavoriteProduct(userID: String, favoriteProductID: String) async throws {
        try await userFavoriteProductDocument(userID: userID, favoriteProductID: favoriteProductID).delete()
    }
    
    /////
    
    
    
    func getAllUserFavoriteProducts(userID: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userID: userID).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func getAllUserMatches(userID: String) async throws -> [UserMatch] {
        try await userMatchesCollection(userID: userID).getDocuments(as: UserMatch.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    func removeListenerForAllUserMatches() {
        self.userMatchesListener?.remove()
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
   
    
    
    func addListenerForAllUserFavoriteProducts(userID: String, completion: @escaping (_ products: [UserFavoriteProduct]) -> Void) {
                
        self.userFavoriteProductsListener = userFavoriteProductCollection(userID: userID).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            let products: [UserFavoriteProduct] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: UserFavoriteProduct.self)
            }
            completion(products)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New products: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified products: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed products: \(diff.document.data())")
                }
                
                
            }
        }
        
    }
    
    /*
    func addListenerForAllUserMatches(userID: String, completion: @escaping (_ products: [UserMatch]) -> Void) {
                
        self.userMatchesListener = userMatchesCollection(userID: userID).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            let matches: [UserMatch] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: UserMatch.self)
            }
            completion(matches)
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New products: \(diff.document.data())")
                }
                if (diff.type == .modified) {
                    print("Modified products: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed products: \(diff.document.data())")
                }
                
                
            }
        }
        
    }
    */
    
    func addListenerForAllUserFavoriteProducts(userID: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
                
        let (publisher, listener) = userFavoriteProductCollection(userID: userID)
            .addSnapshotListener(as: UserFavoriteProduct.self)


        self.userFavoriteProductsListener = listener
        return publisher
    }
        
    func addListenerForAllUserMatches(userID: String, isCompleted: Bool) -> AnyPublisher<[UserMatch], Error> {
                
        let (publisher, listener) = userMatchesCollection(userID: userID)
            .whereField(UserMatch.CodingKeys.isCompleted.rawValue, isEqualTo: isCompleted)
            .order(by: UserMatch.CodingKeys.dateCreated.rawValue, descending: true)
            .addSnapshotListener(as: UserMatch.self)
        
        self.userMatchesListener = listener
        return publisher
    }
    
    
    
}

struct UserFavoriteProduct: Codable {
    let id: String
    let productID: Int
    let dateCreated: Date
}

// the UserMatch is a list of matche IDs that the user is or was part of
// these are all case sensitive
struct UserMatch: Identifiable, Codable, Equatable {
    let id: String
    let matchID: String
    let isCompleted: Bool
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

