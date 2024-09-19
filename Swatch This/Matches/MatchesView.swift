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
    // @EnvironmentObject var gameData: GameData
    
    
    var body: some View {
        List {
            
            // should maybe swap this out with a listener for all matches and then filter here with .filter { $0.isCompleted }
            // though, it'll be good to have the current match listener stay active outside of this view. We don't need the completed matches
            // listener to stay active
            
            Section(header: Text("Current Matches")) {
                ForEach(viewModel.userActiveMatches, id: \.id.self) { item in
                    
                    Button(action: {
                        
                        viewModel.getMatchData(userMatch: item)
                        self.viewRouter.currentPage = "game"

                        
                    }, label: {
                        Text("item.matchID: \(item.matchID)")
                    })
                    
                }
            }
            
            Section(header: Text("New Match")) {
                
                Button(action: {
                    
                    MatchesManager.shared.createMatch()
                    
                    self.viewRouter.currentPage = "game"
                    
                    
                    
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
