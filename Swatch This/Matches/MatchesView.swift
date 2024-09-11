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
    
    var body: some View {
        List {
            
            Section(header: Text("Current Matches")) {
                ForEach(viewModel.userActiveMatches, id: \.id.self) { item in
                    Text("item.isCompleted: \(item.isCompleted)")
                    
                }
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
