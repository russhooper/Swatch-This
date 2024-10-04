//
//  ProfanityFilter.swift
//  ProfanityFilter
//
//  Created by Russ Hooper on 10/4/2024.
//

import Foundation

open class ProfanityFilter {
    
    static var words: [String] {
        let fileName = Bundle(for: ProfanityFilter.self).path(forResource: "ProfanityWords", ofType: "txt")!
        let wordStr = try? String(contentsOfFile: fileName)
        let wordArray = wordStr!.components(separatedBy: CharacterSet.newlines)
        return wordArray
    }
}

