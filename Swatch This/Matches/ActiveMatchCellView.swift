import SwiftUI

struct ActiveMatchCellView: View {
    let match: Match
    var rotations: [Double]
    let offsetsY: [Double]
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center) {
                swatchesView(match: match, geoWidth: geo.size.width, geoHeight: geo.size.height)
                
                Spacer() // This pushes the textView to the right
                
                textView(match: match)
                    .frame(width: geo.size.width * 1 / 2, height: geo.size.height, alignment: .trailing)
                
              //  Image(systemName: "arrowtriangle.forward.fill").tint(Color.tangerine)
            }
        }
    }
    
    func swatchesView(match: Match, geoWidth: CGFloat, geoHeight: CGFloat) -> some View {
        
        return Group {
            
            ZStack {
                
                ForEach(0 ..< match.colorIndices.count, id: \.self) { i in
                    
                    SwatchView(colorIndices: match.colorIndices.reversed(),
                               colorAtIndex: i,
                               swatchHeight: geoHeight*0.95,
                               shadowOpacity: 0.35,
                               shadowRadius: 3
                               )
                    .rotationEffect(.degrees(rotations[i]))
                    .offset(x: CGFloat(i-1) * geoWidth / 16, y: offsetsY[i])
                }
            }
        }
    }
    
    func textView(match: Match) -> some View {
        
        // Initialize userNamesArray with an empty array by default
        let userNamesArray: [String] = match.playerDisplayNames?.values.map { $0 } ?? []
        
        var actionText: String = ""
        let canTakeTurn = GameBrain().determineGameState(localPlayerID: LocalUser.shared.userID, match: match).canTakeAction
        if canTakeTurn == true {
            actionText = "Your turn!"
        } else {
            actionText = "Another player's turn"
        }
        
        return Group {
            VStack(alignment: .trailing, spacing: 4) {  // Right alignment
                
                Text(actionText)
                    .font(.headline)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(userNamesArray.joined(separator: ", "))
                 //   .font(.callout)
                    .foregroundColor(.white)
                Text(match.turnLastTakenDate != nil ? formatDate(match.turnLastTakenDate!) : "No turns taken")
                  //  .font(.callout)
                    .foregroundColor(.white)
                    .padding(.bottom)
                
                Spacer()
            }
        }
    }
}
