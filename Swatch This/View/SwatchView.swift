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
    let colorName: String?
    let company: String?
    let colorURL: String?
    let coverOpacity: Double?
    let logoOpacity: Double?
    let nameOpacity: Double?
    let shadowOpacity: Double?
    let shadowRadius: Double?
    let fontSize: CGFloat?
    let showTurns: Bool?
    
    // Provide default values for optional parameters
        init(
            colorIndices: [Int],
            colorAtIndex: Int,
            swatchHeight: CGFloat,
            colorName: String = "",
            company: String = "",
            colorURL: String = "https://swatchthisgame.com",
            coverOpacity: Double = 1.0,
            logoOpacity: Double = 1.0,
            nameOpacity: Double = 1.0,
            shadowOpacity: Double = 0.25,
            shadowRadius: Double = 5,
            fontSize: CGFloat = 10.0,
            showTurns: Bool = false
        ) {
            self.colorIndices = colorIndices
            self.colorAtIndex = colorAtIndex
            self.swatchHeight = swatchHeight
            self.colorName = colorName
            self.company = company
            self.colorURL = colorURL
            self.coverOpacity = coverOpacity
            self.logoOpacity = logoOpacity
            self.nameOpacity = nameOpacity
            self.shadowOpacity = shadowOpacity
            self.shadowRadius = shadowRadius
            self.fontSize = fontSize
            self.showTurns = showTurns
        }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack {
                
                ZStack(alignment: .top) {
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight+swatchHeight*0.39, alignment: .center)
                        .foregroundColor(.white)
                        .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: shadowOpacity ?? 0.25),
                                radius: shadowRadius ?? 5,
                                y: 3)
                    
                    VStack(alignment: .leading) {
                        
                        ZStack(alignment: .center) {
                            
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: swatchHeight, height: swatchHeight, alignment: .center)
                                .foregroundColor(hexColor(GameBrain().getColorHex(turn: colorAtIndex,
                                                                                indexArray: colorIndices)))
                                .padding(EdgeInsets(top: swatchHeight*0.13/2, leading: 0, bottom: 0, trailing: 0))
                            
                            
                            if (showTurns ?? false) {
                                Text("\(colorAtIndex+1)/\(colorIndices.count)")
                                    .font(.system(size: fontSize ?? 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: swatchHeight-30, height: swatchHeight-10, alignment: .bottomTrailing)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                            }
                            
                            if let company = company, !company.isEmpty {
                                VStack(alignment: .leading) {
                                    
                                    Text(company)
                                        .font(.system(size: (fontSize ?? 14)+3))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .opacity(logoOpacity ?? 1.0)
                                        .padding(EdgeInsets(top: swatchHeight*0.13/2, leading: 10, bottom: 0, trailing: 10))
                                    
                                }
                            }
                        }
                        
                        if let colorName = colorName {
                            Text(colorName)
                                .font(.system(size: fontSize ?? 14))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .opacity(nameOpacity ?? 1.0)
                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        if let colorURL = colorURL, !colorURL.isEmpty {

                            if showTurns == true { // Tabletop mode. We need a spacer due to its size
                                Button("View this \(colorLocalized) online") {UIApplication.shared.open(URL(string: colorURL)!)}
                                    .font(.system(size: (fontSize ?? 14)-3))
                                    .opacity(nameOpacity ?? 1.0)
                                    .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                                
                            } else { // Pass & Play or Online
                                
                                Button("View this \(colorLocalized) online") {UIApplication.shared.open(URL(string: colorURL)!)}
                                    .font(.system(size: (fontSize ?? 14)-2))
                                    .opacity(nameOpacity ?? 1.0)
                            }
                        }
                    }
                }
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight*0.39, alignment: .center)
                .foregroundColor(.white)
                .opacity(coverOpacity ?? 1.0)
        }
        .accentColor(Color.tangerineText)

    }
}

/*
 struct SwatchView_Previews: PreviewProvider {
 static var previews: some View {
 SwatchView()
 }
 }
 */
