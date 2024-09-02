//
//  UserManager.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
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
    
    /* // superceded by mutating func, which is cleaner and doesn't expose the inner workings of the DBUser to other files
     func togglePremiumStatus() -> DBUser {
     let currentPremiumStatus = isPremium ?? false
     return DBUser(
     userID: userID,
     isAnonymous: isAnonymous,
     email: email,
     photoURL: photoURL,
     dateCreated: dateCreated,
     isPremium: !currentPremiumStatus)
     }
     */
    
    /* // superceded by updateUserPremiumStatus, which is safer
     mutating func togglePremiumStatus() {
     let currentPremiumStatus = isPremium ?? false
     isPremium = !currentPremiumStatus
     }
     */
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }
    
    private func userFavoriteProductCollection(userID: String) -> CollectionReference {
        let collectionRef = userDocument(userID: userID).collection("favoriteProducts")
      //  print("collectionRef: \(collectionRef)")
        return collectionRef
    }
    
    private func userFavoriteProductDocument(userID: String, favoriteProductID: String) -> DocumentReference {
        let favDoc = userFavoriteProductCollection(userID: userID).document(favoriteProductID)
      //  print("favDoc: \(favDoc)")
        return favDoc
    }
    
    /* // no longer need encoder/decoder as I'm just using camelCase in database
     private let encoder: Firestore.Encoder = {
     let encoder = Firestore.Encoder()
     encoder.keyEncodingStrategy = .convertToSnakeCase
     return encoder
     }()
     
     private let decoder: Firestore.Decoder = {
     let decoder = Firestore.Decoder()
     decoder.keyDecodingStrategy = .convertFromSnakeCase
     return decoder
     }()
     */
    
    private var userFavoriteProductsListener: ListenerRegistration? = nil
    
    
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    // previous function is a much cleaner way of doing this
    //    func createNewUser(auth: AuthDataResultModel) async throws {
    //        var userData: [String : Any] = [
    //            "user_id" : auth.uid,
    //            "is_anonymous" : auth.isAnonymous,
    //            "date_created" : Timestamp(),
    //        ]
    //
    //        if let email = auth.email {
    //            userData["email"] = email
    //        }
    //
    //        if let photoURL = auth.photoUrl {
    //            userData["photo_url"] = photoURL
    //        }
    //
    //        try await userDocument(userID: auth.uid).setData(userData, merge: false)
    //
    //    }
    
    func getUser(userID: String) async throws -> DBUser {
        print("userID: \(userID)")
        return try await userDocument(userID: userID).getDocument(as: DBUser.self)
    }
    
    //    // previous function is a much cleaner way of doing this
    //    func getUser(userID: String) async throws -> DBUser {
    //        let snapshot = try await userDocument(userID: userID).getDocument()
    //
    //        guard let data = snapshot.data(), let userID = data["user_id"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        let isAnonymous = data["is_anonymous"] as? Bool
    //        let email = data["email"] as? String
    //        let photoURL = data["photo_url"] as? String
    //        let dateCreated = data["date_created"] as? Date
    //
    //        return DBUser(userID: userID, isAnonymous: isAnonymous, email: email, photoURL: photoURL, dateCreated: dateCreated)
    //
    //    }
    
    
    /*
     // this is dangerous because it updates all fields in the database for this user, not just premiumStatus
     func updateUserPremiumStatus(user: DBUser) async throws {
     try userDocument(userID: user.userID).setData(from: user, merge: true)
     }
     */
    
    func updateUserPremiumStatus(userID: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            "isPremium": isPremium
        ]
        
        try await userDocument(userID: userID).updateData(data)
    }
    
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
    
    /*
    func getAllUserFavoriteProducts(userID: String) async throws -> [UserFavoriteProduct] {
        print("userID: \(userID)")
        
        
        // Get the Firestore reference
        let db = Firestore.firestore()
        
        /*
        // Reference the document in Firestore
        let favoriteProductID = "3Sy5hNn93EfI1tt2Ijhd"  // Replace with your actual favorite product ID
        let favoriteProductDocRef = db.collection("users").document(userID).collection("favoriteProducts").document(favoriteProductID)

        // Fetch the document
        favoriteProductDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                print("Favorite Product Data: \(String(describing: data))")
            } else {
                print("Document does not exist or error: \(String(describing: error))")
            }
        }
        */
       
        let collection = userFavoriteProductCollection(userID: userID)
        print("collection: \(String(describing: collection))")

        // Reference the collection in Firestore
     //   let favoriteProductsCollectionRef = db.collection("users").document(userID).collection("favoriteProducts")
        let favoriteProductsCollectionRef = collection

        var favoriteProducts: [UserFavoriteProduct] = []

        
        // Fetch all documents in the collection
        favoriteProductsCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    
                    print("Favorite document: \(document)")

                    
                    let product: UserFavoriteProduct = UserFavoriteProduct(id: "abc", productID: 1, dateCreated: Date())
                    
                    
                    // Append each document ID to the array
                    favoriteProducts.append(product)
                    // If you need the document data:
                   //  let data = document.data()
                   //  print("Favorite Product Data 2: \(data)")
                }
                print("Favorite Products: \(favoriteProducts)")
                return favoriteProducts
            }
        }
        
        
        
        
        let favDocs = try await collection.getDocuments(as: UserFavoriteProduct.self)
        
        
        /*
        guard let collectionTest = try? await userFavoriteProductCollection(userID: userID).getDocuments(as: UserFavoriteProduct.self) else {
            throw URLError(.badURL)
        }
        */
     //   print("favDocs: \(favDocs)")
    
    }
    */
    
    func getAllUserFavoriteProducts(userID: String) async throws -> [UserFavoriteProduct] {
        try await userFavoriteProductCollection(userID: userID).getDocuments(as: UserFavoriteProduct.self)
    }
    
    func removeListenerForAllUserFavoriteProducts() {
        self.userFavoriteProductsListener?.remove()
    }
    
    
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
    func addListenerForAllUserFavoriteProducts(userID: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
                
        let publisher = PassthroughSubject<[UserFavoriteProduct], Error>()
        
        self.userFavoriteProductsListener = userFavoriteProductCollection(userID: userID).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            let products: [UserFavoriteProduct] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: UserFavoriteProduct.self)
            }
            publisher.send(products)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    */
    
    
    func addListenerForAllUserFavoriteProducts(userID: String) -> AnyPublisher<[UserFavoriteProduct], Error> {
                
        let (publisher, listener) = userFavoriteProductCollection(userID: userID)
            .addSnapshotListener(as: UserFavoriteProduct.self)
        
        self.userFavoriteProductsListener = listener
        return publisher
    }
    
}

struct UserFavoriteProduct: Codable {
    let id: String
    let productID: Int
    let dateCreated: Date
}
