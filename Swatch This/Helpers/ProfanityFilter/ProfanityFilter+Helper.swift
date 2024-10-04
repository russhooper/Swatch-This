//
//  ProfanityFilter+Helper.swift
//  ProfanityFilter
//
//  Created by Russ Hooper on 10/4/2024.
//

import Foundation

public extension String {
    
    func profanityFiltered(_ replaceWith: String = "") -> String {
        
        let contains = ProfanityFilter.words.contains {
            self.range(of: $0, options: .caseInsensitive) != nil
        }
        guard contains else {
            return self
        }
        return String(repeating: replaceWith, count: self.count)
    }
    
    func containsProfanity() -> Bool {
        let contains = ProfanityFilter.words.contains {
            self.range(of: $0, options: .caseInsensitive) != nil
        }
        if contains {
            return true
        } else {
            return false
        }
        
    }
    
}
