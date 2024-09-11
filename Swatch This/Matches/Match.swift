//
//  Match.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation


// these are all case sensitive
struct Match: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let description: String?
    let price: Int?
    let discountPercentage: Double?
    let rating: Double?
    let stock: Int?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
    
    let matchID: String
    let phase: Int?
    let playerIDs: [String]?
    let appVersion: Float?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case category
        case thumbnail
        case images
        
        case matchID
        case phase
        case playerIDs
        case appVersion
    }
    
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
}
