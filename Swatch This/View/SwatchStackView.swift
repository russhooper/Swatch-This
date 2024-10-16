//
//  SwatchStackView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/24/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import UIKit

struct SwatchStackView: View {
    
    let swatchColor: Color
    let swatchHeight: CGFloat
    let text: String
    var textField: Binding<String>?
    let subtext: String
    let fontSize: CGFloat
    let inGame: Bool
    let turnNumber: Int
    
    
    var body: some View {
        
        
        VStack {
            
            
            ZStack(alignment: .top) {
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: self.swatchHeight+self.swatchHeight*0.13, height: self.swatchHeight+self.swatchHeight*0.4, alignment: .center)
                    .foregroundColor(.white)
                    .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.35),
                            radius: 5,
                            y: 3)
                
                
                VStack(alignment: .leading) {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: self.swatchHeight, height: self.swatchHeight, alignment: .center)
                            .foregroundColor(swatchColor)
                            .padding(EdgeInsets(top: self.swatchHeight*0.13/2, leading: 0, bottom: 0, trailing: 0))
                        
                        if inGame == true {
                            Text("\(turnNumber+1)/4")
                                .font(.system(size: fontSize+5))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: self.swatchHeight-30, height: self.swatchHeight-10, alignment: .bottomTrailing)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                        }
                       
                        
                    }
                    
                    if inGame == true {
                        
                        TextField("Name this \(colorLocalized)", text: self.textField!)
                            .frame(width: self.swatchHeight, alignment: .leading)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        
                        
                        Button(action: {
                            
                            // clear the textfield
                            
                        }) {
                            Text("Submit")
                                .font(.system(size: 18))
                                .bold()
                        }
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                        //.disabled(self.textField?.count < 2)
                        
                        
                    } else {
                        
                        Text(self.text)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text(subtext)
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        
                    }
                    
                }
            }
        }
        .accentColor(Color.tangerineText)

    }
}

/*
struct SwatchStackView_Previews: PreviewProvider {
    static var previews: some View {
        SwatchStackView()
    }
}
*/
