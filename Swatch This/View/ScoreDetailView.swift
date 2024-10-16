//
//  ScoreDetailView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/21/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI

struct ScoreDetailView: View {
    
    var gameData: GameData
    let playerString: String
    let onlineGame: Bool
    let customSplitView: Bool
    
        
    
    var body: some View {
            
        GeometryReader(content: geometricView(with:))
        
    }
    
    func geometricView(with geometry: GeometryProxy) -> some View {
                
        let titleString = self.gameData.displayNames[self.playerString] ?? self.playerString
        
    /*
        let avatar = GameKitHelper.sharedInstance.getPlayerAvatar(playerAlias: titleString) { playerAvatars in
            
        }
        */
        
        
    //    if customSplitView == true {
    //        titleColor = Color(brightTeal)
    //    }
        
        return Group {
            
            ZStack {
                
              //  if customSplitView == false {
              //      Color(self.mediumTealColor)
             //           .edgesIgnoringSafeArea(.all)
             //   }
                
         
                
                VStack {
                    
                    /*
                    Spacer()
                    
                      
                    Text(titleString)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(titleColor)
                        .padding()
                       
                    
                    Spacer()
 */
 
                   
                    
                    List(0...3, id: \.self) { round in
                        
                        // ForEach(0..<2) { column in
                        
                        // playersByRound[round][what player is this?][get "Created" key]
                        let created = self.gameData.playersByRound[round][GameBrain().getPlayerInt(playerString: self.playerString) - 1]["Created"]!
                        
                        // playersByRound[round][what player is this?][get "Guessed" key]
                        let guessed = self.gameData.playersByRound[round][GameBrain().getPlayerInt(playerString: self.playerString) - 1]["Guessed"]!
                           
                        
                        let scoreDetailArray: [String]? = GameBrain().getScoreDetailList(created: created, guessed: guessed,
                                                                                       actual: GameBrain().getColorName(turn: round, indexArray: self.gameData.colorIndices),
                                                                                       playersThisRound: self.gameData.playersByRound[round],
                                                                                       userNames: self.gameData.displayNames)
                        
                        
                        HStack(spacing: 20) {
                            
                            
                            SwatchView(colorIndices: self.gameData.colorIndices,
                                       colorAtIndex: round,
                                       swatchHeight: 130,
                                       colorName: GameBrain().getColorName(turn: round, indexArray: self.gameData.colorIndices),
                                       nameOpacity: 1.0,
                                       fontSize: 12)
                                //  .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .rotationEffect(.degrees(-6))
                            
                            VStack {
                                
                                
                                Spacer()
                                
                                if scoreDetailArray != nil {
                                    
                                    List(0...scoreDetailArray!.count-1, id: \.self) { counter in
                                        
                                        Text(scoreDetailArray![counter])
                                        /*
                                            .foregroundColor(scoreDetailArray![counter].prefix(1) == "+" ? Color(GameBrain().getColorHexForScoreDetail(turn: round, indexArray: self.gameData.colorIndices)) : .black)
                                        */
                                    }
                                    .listStyle(.plain)

                                }
                            }
                            
                            
                            
                        }
                        
                    }
                    .listStyle(.plain)

                }
                
            }
            .accentColor(Color.tangerineText)
            .navigationTitle(titleString)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    

}

/*
 struct ScoreDetailView_Previews: PreviewProvider {
 static var previews: some View {
 ScoreDetailView()
 }
 }
 */
