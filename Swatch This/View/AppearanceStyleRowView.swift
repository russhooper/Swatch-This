//
//  AppearanceStyleRowView.swift
//  Swatch This
//
//  Created by Russ Hooper on 10/10/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

struct AppearanceStyleRowView: View {
    
    let appearanceStyle: String
    let showSelected: Bool
    
    var body: some View {
        
        HStack {
            Text(appearanceStyle)
                .tint(Color.whiteBlackText)
            Spacer()
            
            Image(systemName: showSelected ? "largecircle.fill.circle" : "circle")
                .tint(Color.tangerineText)
        }

    }
}

/*
#Preview {
    AppearanceStyleRowView()
}
*/
