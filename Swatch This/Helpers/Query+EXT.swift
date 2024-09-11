//
//  Query+EXT.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift
import Combine


extension Query {
    
    // generic with T for Type
    //    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
    //        let snapshot = try await self.getDocuments()
    //
    //        return try snapshot.documents.map({ document in
    //            try document.data(as: T.self)
    //        })
    //    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        
        
        let (products, _) = try await self.getDocumentsWithSnapshot(as: type)
      //  print("products1: \(products)")
        return products
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> ([T], DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
      //  print("snapshot: \(snapshot)")

        let products = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
     //   print("snapshot.documents: \(snapshot.documents)")
      //  print("products2: \(products)")

        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else {
            return self
        }
        
        return self.start(afterDocument: lastDocument)
    }
    
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        // return both publisher and listener
        
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents")
                return
            }
            
            let products: [T] = documents.compactMap { documentSnapshot in
                print("documents found")
                return try? documentSnapshot.data(as: T.self)
            }
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
    
    
}


