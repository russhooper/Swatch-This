//
//  ColorCodes.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/30/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation

// can use this to upload fake data to Firebase
func uploadCodesToFirebase() {
    
    Task {
        do {
         //   let (data, response) = try await URLSession.shared.data(from: url)
        //    let products = try JSONDecoder().decode (ProductArray.self, from: data)
            
            let codeArray = ColorCodes.colors
            
            for code in codeArray {
                try? await MatchCodeManager().uploadCode(code: code)
            }
            
            print("Success: \(codeArray.count)")
        }
    }
     
    
}

final class ColorCodes {
 
    static let colors: [MatchCode] = [
        MatchCode(id: "2001", code: "basil smash", hex: "#b7e1a1")
       
        // copy in codes here to upload to Firebase
        
    ]
    
}
