//
//  MatchCodeManager.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/29/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import FirebaseFirestore

final class MatchCodeManager {
    
    private let codesCollection = Firestore.firestore().collection("MatchCodes")

    private func codeDocument(id: String) -> DocumentReference {
        let docRef = codesCollection.document(id)
       // print("docRef: \(docRef)")
        return docRef
    }
    
    func getRandomCode() async throws -> String? {
        
        let count = try await getAllMatchCodesCount()
        let randomIndex = Int.random(in: 0..<count)
                
        let query = getCodesForIndex(index: randomIndex)
        
        let (codes, _) = try await query
            .getDocumentsWithSnapshot(as: MatchCode.self)
        // This function returns a tuple. (codes, _) will get the first object of the tuple
        
        if let code = codes.first?.code {
            
            if try await MatchesManager.shared.checkMatchCode(password: code) != nil {
                
                return nil
            }
            
            return code

        } else {
            return nil
        }
    }
    
    private func getCodesForIndex(index: Int) -> Query {
        codesCollection
            .whereField(MatchCode.CodingKeys.id.rawValue, isEqualTo: String(index))
    }
        
    func getAllMatchCodesCount() async throws -> Int {
        try await codesCollection.aggregateCount()
    }
    
    func uploadCode(code: MatchCode) async throws {
        try codeDocument(id: code.id).setData(from: code, merge: false)
    }
    
}
