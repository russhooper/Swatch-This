//
//  TransitionSwatches.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/13/21.
//  Copyright © 2021 Radio Silence. All rights reserved.
//

import SwiftUI

/*
final class TransitionSwatches: ObservableObject {
    
    var geoWidth: CGFloat = 100 // placeholder values
    var geoHeight: CGFloat = 100
    
    @Published var transitionSwatchs = [TransitionSwatch]()

    
    init() {
        
        self.transitionSwatchs.append(TransitionSwatch(id: 0, opacity: 0, offsetX: CGFloat.random(in: -geoWidth ..< geoWidth), offsetY: CGFloat.random(in: -geoHeight ..< geoHeight), rotation: Double.random(in: -15 ..< 15)))
        self.transitionSwatchs.append(TransitionSwatch(id: 1, opacity: 0, offsetX: CGFloat.random(in: -geoWidth ..< geoWidth), offsetY: CGFloat.random(in: -geoHeight ..< geoHeight), rotation: Double.random(in: -15 ..< 15)))
        self.transitionSwatchs.append(TransitionSwatch(id: 2, opacity: 0, offsetX: CGFloat.random(in: -geoWidth ..< geoWidth), offsetY: CGFloat.random(in: -geoHeight ..< geoHeight), rotation: Double.random(in: -15 ..< 15)))
    }
    
    /*
    @Published var swatches = [
            TransitionSwatch(id: 0, opacity: 0, offsetX: CGFloat.random(in: -1 * geoWidth ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 1, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 2, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 3, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 4, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 5, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 6, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 7, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 8, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 9, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15)),
        TransitionSwatch(id: 10, opacity: 0, offsetX: CGFloat.random(in: -300 ..< 300), offsetY: CGFloat.random(in: -300 ..< 300), rotation: Double.random(in: -15 ..< 15))

        ]
    */
    
}
*/

class TransitionSwatches: ObservableObject {
    
    @Published var swatches = [TransitionSwatch]()
    
    
    init() {
        
        self.swatches.append(TransitionSwatch(id: 0, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 0))
        self.swatches.append(TransitionSwatch(id: 1, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 1))
        self.swatches.append(TransitionSwatch(id: 2, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 3, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))
        self.swatches.append(TransitionSwatch(id: 4, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))
        self.swatches.append(TransitionSwatch(id: 5, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 6, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 0))
        self.swatches.append(TransitionSwatch(id: 7, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 1))
        self.swatches.append(TransitionSwatch(id: 8, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))
        self.swatches.append(TransitionSwatch(id: 9, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 10, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 0))
        self.swatches.append(TransitionSwatch(id: 11, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 1))
        self.swatches.append(TransitionSwatch(id: 12, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))
        self.swatches.append(TransitionSwatch(id: 13, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 14, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 1))
        self.swatches.append(TransitionSwatch(id: 15, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 16, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 0))
        self.swatches.append(TransitionSwatch(id: 17, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))
        self.swatches.append(TransitionSwatch(id: 18, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 1))
        self.swatches.append(TransitionSwatch(id: 19, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 20, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 0))
        self.swatches.append(TransitionSwatch(id: 21, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))
        self.swatches.append(TransitionSwatch(id: 22, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 1))
        self.swatches.append(TransitionSwatch(id: 23, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 2))
        self.swatches.append(TransitionSwatch(id: 24, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 0))
        self.swatches.append(TransitionSwatch(id: 25, opacity: 0, offsetX: 0, offsetY: 0, rotation: Double.random(in: -15 ..< 15), turn: 3))

    }
    
    func updateOpacity(id: TransitionSwatch, opacity: Double){
        
        for i in 0..<swatches.count{
            
            if swatches[i].id == id.id {
                
                self.swatches[i].opacity = opacity
            }
        }
    }
    
    func updateFrame(geoWidth: CGFloat, geoHeight: CGFloat){
    
    
        // this is to safeguard against updateFrame being called with no geometry
        var geoWidthVar = geoWidth
        var geoHeightVar = geoHeight
        
        if geoWidthVar == 0 {
            geoWidthVar = 700
        }
        
        if geoHeightVar == 0 {
            geoHeightVar = 1000
        }
        
        
        
        
        // to ensure we plaster the whole screen, we'll put the swatches in quadrants
        
        let factor: CGFloat = 2
        
        for i in 0 ..< swatches.count{
            
            self.swatches[i].turn = Int.random(in: 0 ..< 4)
            
            if i % 4 == 0 {
                
                self.swatches[i].offsetX = CGFloat.random(in: -geoWidthVar/factor ..< 0)
                self.swatches[i].offsetY = CGFloat.random(in: -geoHeightVar/factor ..< 0)
                
            } else if i % 4 == 1 {
                
                self.swatches[i].offsetX = CGFloat.random(in: 0 ..< geoWidthVar/factor)
                self.swatches[i].offsetY = CGFloat.random(in: -geoHeightVar/factor ..< 0)
                
            } else if i % 4 == 2 {
                
                self.swatches[i].offsetX = CGFloat.random(in: -geoWidthVar/factor ..< 0)
                self.swatches[i].offsetY = CGFloat.random(in: 0 ..< geoHeightVar/factor)
                
            } else {
                
                self.swatches[i].offsetX = CGFloat.random(in: 0 ..< geoWidthVar/factor)
                self.swatches[i].offsetY = CGFloat.random(in: 0 ..< geoHeightVar/factor)
                
            }
               
        }
        
        
        
      
    }
    
    
}


struct TransitionSwatch: Identifiable {
    
    var id: Int
    var opacity: Double
    var offsetX: CGFloat
    var offsetY: CGFloat
    var rotation: Double
    var turn: Int // for the color index
    
}

