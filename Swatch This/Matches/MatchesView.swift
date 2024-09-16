//
//  MatchesView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

struct MatchesView: View {
    
    @StateObject private var viewModel = MatchesViewModel()
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var gameData: GameData

    
    var body: some View {
        List {
            
            // should maybe swap this out with a listener for all matches and then filter here with .filter { $0.isCompleted }
            
            Section(header: Text("Current Matches")) {
                ForEach(viewModel.userActiveMatches, id: \.id.self) { item in
                    
                    Button(action: {
                        Task {
                            do {
                                let match = try await MatchesManager.shared.getMatch(matchID: item.matchID)
                                print(match.matchID)
                                
                                
                                
                           //     self.gameData.colorIndices = match.colorIndices ?? [0, 0, 0, 0] // if this resets to default colors we'll have a problem. Should maybe show an error message instead?
                                
                                /*
                                ContentView(gameData: self.gameData,
                                            turnData: self.turnData,
                                            playerCount: self.viewRouter.playerCount,
                                            onlineGame: false,
                                            colorIndices: self.gameData.colorIndices,
                                            playDealAnimation: false) // should match onlineGame
                                */
                                
                                self.viewRouter.currentPage = "game"

                                
                            } catch {
                                print(error)
                            }
                        }
                        
                        
                    }, label: {
                        Text("item.matchID: \(item.matchID)")

                    })
                    
                    
                }
            }
            
            Section(header: Text("New Match")) {
                    
                    Button(action: {
                      //  Task {
                      //      do {
                            
                                MatchesManager.shared.createMatch()
                                
                                
                                self.viewRouter.currentPage = "game"

                                
                       //     } catch {
                       //         print(error)
                       //     }
                      //  }
                        
                        
                    }, label: {
                        Image(systemName: "plus.square.fill")
                    })
                    
                    
            }
            
            Section(header: Text("Completed Matches")) {
                ForEach(viewModel.userCompletedMatches, id: \.id.self) { item in
                    Text("item.isCompleted: \(item.isCompleted)")
                }
            }
            
        }
        .navigationTitle("Matches")
        .onFirstAppear {
          //  viewModel.getMatches()
            
            viewModel.addListenerForActiveMatches()
            viewModel.addListenerForCompletedMatches()
            
        }
    }
}

#Preview {
    MatchesView()
}
