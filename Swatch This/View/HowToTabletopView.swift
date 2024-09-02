//
//  HowToTabletopView.swift
//  Swatch This
//
//  Created by Russ Hooper on 2/23/21.
//  Copyright © 2021 Radio Silence. All rights reserved.
//

import SwiftUI

struct HowToTabletopView: View {

    
    let tangerineColor: UInt32 = 0xFF9B54
    let blushColor: UInt32 = 0xf95352
    let darkGreenColor: UInt32 = 0x395865
    
    
    let instructionsArray = [
        "Pick the person wearing the most \(colorLocalized)ful clothes to be leader for the first round.",
        "Keeping the \(colorLocalized) name hidden, the leader will show all the players the \(colorLocalized) in the first swatch.",
        "The leader will then check the real \(colorLocalized) name, making sure to not let any of the other players see the name.",
        "All the other players will write down a made-up name they think describes the \(colorLocalized) and hand it to the leader.",
        "The leader will read these in random order, with the real name mixed in. The other players must guess which name is correct.",
        "Tally points, and designate a new leader for the next round.",
        "At the end of the 3 \(colorLocalized)s, the person with the most points is the master \(colorLocalized)smith!"
    ]
    
    
    let scoringArray = [
        "Guessing the correct \(colorLocalized) name earns a player 1 point.",
        "For each player fooled by a made-up \(colorLocalized) name, award the name creator 1 point.",
        "If no one guesses the real \(colorLocalized) name correctly, award the round leader 1 point."
    ]
    
    var body: some View {
        
        VStack {
            
            GeometryReader(content: geometricView(with:))
            
        }
        
        
        
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        

        
        return Group {
            
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    
                    
                 
                    // All the other players will write down their made-up paint color name on a piece of paper and give it to the leader. After all submissions, the leader will read the submitted names along with the real one. Players then take turns guessing the real name.
                    
                  
                    
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Color(brightTealColor))

                        HStack {
                            
                            Text("What you'll need:")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                            
                            Spacer()
                            
                        }
                        
                        
                    }
                    .frame(width: geometry.size.width, height: 60)

                    
                    
                    Text("Some things to write on and things to write with.")
                        .font(.body)
                        .padding()
                    
                    
                    Spacer()
                    
        
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Color(brightTealColor))

                        HStack {
                            
                            Text("How to play:")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                            
                            Spacer()
                            
                        
                        }
                        
                        
                    }
                    .frame(width: geometry.size.width, height: 60)

                    
                    
                    ForEach(self.instructionsArray, id: \.self) { line in
                        
                        Text(line)
                            .font(.body)
                            .padding()
                        
                    }
                    
                    
                    Spacer()
                    
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Color(brightTealColor))

                        
                        HStack {
                            
                        Text("Scoring:")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            
                            Spacer()
                            
                        }
                        
                    }
                    .frame(width: geometry.size.width, height: 60)
                    
                  
                    ForEach(self.scoringArray, id: \.self) { line in
                        
                        Text(line)
                            .font(.body)
                            .padding()
                        
                    }
                    
                    
                  
                    
                    
                }
            }
        }
    }
    
    
}
