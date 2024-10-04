//
//  MatchCode.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/29/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation

struct MatchCode: Identifiable, Codable, Equatable {
    let id: String // need id for Identifiable
    let code: String
    let hex: String

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case hex
    }
    
    static func ==(lhs: MatchCode, rhs: MatchCode) -> Bool {
        return lhs.id == rhs.id
    }
}

