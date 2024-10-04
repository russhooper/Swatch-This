//
//  CurrentMatchCellView.swift
//  Swatch This
//
//  Created by Russ Hooper on 10/3/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

struct ActiveMatchCellView: View {
    let userMatch: UserMatch
    var rotations: [Double]
    let offsetsY: [Double]
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                swatchesView(userMatch: userMatch, geoWidth: geo.size.width, geoHeight: geo.size.height)
                
                Spacer()
                
                textView(userMatch: userMatch)
                    .frame(width: geo.size.width * 1 / 2)
            }
        }
    }
    
    func swatchesView(userMatch: UserMatch, geoWidth: CGFloat, geoHeight: CGFloat) -> some View {
        
        return Group {
            
            ZStack {
                
                ForEach(0 ..< userMatch.match.colorIndices.count, id: \.self) {i in
                    
                    SwatchView(colorIndices: userMatch.match.colorIndices.reversed(),
                               colorAtIndex: i,
                               swatchHeight: geoHeight, //geo.size.height
                               colorName: "",
                               company: "",
                               colorURL: "",
                               coverOpacity: 0.0,
                               logoOpacity: 0.0,
                               nameOpacity: 0.0,
                               fontSize: 10,
                               showTurns: false)
                    .rotationEffect(.degrees(rotations[i]))
                    .offset(x: CGFloat(i)*geoWidth/16, y: offsetsY[i])
                    
                    
                    
                }
            }
        }
    }
    
    func textView(userMatch: UserMatch) -> some View {
        
        return Group {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userMatch.turnLastTakenDate != nil ? formatDate(userMatch.turnLastTakenDate!) : "No turns taken")                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Phase " + String(userMatch.match.phase ?? 0))
            }
            .font(.callout)
            .foregroundColor(.secondary)
            
        }
    }
}

/*
#Preview {
    ActiveMatchCellView(match: Match(id: "abc123", matchID: "abc123", matchPassword: nil, playerIDs: ["4567a"], colorIndices: [0,20,44,100], appVersion: nil, dateCreated: Date(), turnLastTakenDate: Date(), playerCount: 2),
                        rotations: [-25, -10, 0, 10], offsetsY: [10, 0, -5, -2])
}
*/
