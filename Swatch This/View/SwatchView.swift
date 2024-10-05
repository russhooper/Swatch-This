//
//  SwatchView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/19/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI

struct SwatchView: View {
    
    let colorIndices: [Int]
    let colorAtIndex: Int
    let swatchHeight: CGFloat
    let colorName: String
    let company: String
    let colorURL: String
    let coverOpacity: Double
    let logoOpacity: Double
    let nameOpacity: Double
    let fontSize: CGFloat
    let showTurns: Bool
    

    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack {
                
                
                ZStack(alignment: .top) {
                    
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: self.swatchHeight+self.swatchHeight*0.13, height: self.swatchHeight+self.swatchHeight*0.39, alignment: .center)
                        .foregroundColor(.white)
                        .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.25),
                                radius: 5,
                                y: 3)
                    
                    VStack(alignment: .leading) {
                        
                        ZStack(alignment: .center) {
                            
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: self.swatchHeight, height: self.swatchHeight, alignment: .center)
                                .foregroundColor(hexColor(gameBrain.getColorHex(turn: self.colorAtIndex,
                                                                                indexArray: self.colorIndices)))
                                .padding(EdgeInsets(top: self.swatchHeight*0.13/2, leading: 0, bottom: 0, trailing: 0))
                            
                            
                            if self.showTurns == true {
                                Text("\(self.colorAtIndex+1)/\(self.colorIndices.count)")
                                    .font(.system(size: self.fontSize))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: self.swatchHeight-30, height: self.swatchHeight-10, alignment: .bottomTrailing)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                            }
                            
                            if self.company.count > 0 {
                                VStack(alignment: .leading) {
                                    
                                    Text(self.company)
                                        .font(.system(size: self.fontSize+3))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .opacity(self.logoOpacity)
                                        .padding(EdgeInsets(top: self.swatchHeight*0.13/2, leading: 10, bottom: 0, trailing: 10))
                                    
                                    
                                }
                            }
                            
                            
                        }
                        
                        
                        //  if self.colorName.count > 0 {
                        
                        Text(self.colorName)
                            .font(.system(size: self.fontSize))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .opacity(self.nameOpacity)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))

                        //  }
                        
                        if  self.colorURL.count > 0 {
                            
                            if self.showTurns == true { // Tabletop mode. We need a spacer due to its size
                                Button("View this \(colorLocalized) online") {UIApplication.shared.open(URL(string: self.colorURL)!)}
                                    .font(.system(size: self.fontSize-3))
                                    .opacity(self.nameOpacity)
                                    .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                                
                            } else { // Pass & Play or Online
                                
                                Button("View this \(colorLocalized) online") {UIApplication.shared.open(URL(string: self.colorURL)!)}
                                    .font(.system(size: self.fontSize-2))
                                    .opacity(self.nameOpacity)
                            }
                            
                          

                        }
                        
                    }
                    
                }
                
                
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: self.swatchHeight+self.swatchHeight*0.13, height: self.swatchHeight*0.39, alignment: .center)
                .foregroundColor(.white)
                .opacity(self.coverOpacity)
        }
        .accentColor(Color.tangerineTextColor)

    }
}

/*
 struct SwatchView_Previews: PreviewProvider {
 static var previews: some View {
 SwatchView()
 }
 }
 */
