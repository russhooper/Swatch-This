import SwiftUI

struct ActiveMatchCellView: View {
    let userMatch: UserMatch
    var rotations: [Double]
    let offsetsY: [Double]
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center) {
                swatchesView(userMatch: userMatch, geoWidth: geo.size.width, geoHeight: geo.size.height)
                
                Spacer() // This pushes the textView to the right
                
                textView(userMatch: userMatch)
                    .frame(width: geo.size.width * 1 / 2, alignment: .trailing) // Ensures the text is aligned to the right
            }
        }
    }
    
    func swatchesView(userMatch: UserMatch, geoWidth: CGFloat, geoHeight: CGFloat) -> some View {
        
        return Group {
            
            ZStack {
                
                ForEach(0 ..< userMatch.match.colorIndices.count, id: \.self) { i in
                    
                    SwatchView(colorIndices: userMatch.match.colorIndices.reversed(),
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
    
    func textView(userMatch: UserMatch) -> some View {
        
        // Initialize userNamesArray with an empty array by default
        let userNamesArray: [String] = userMatch.match.playerDisplayNames?.values.map { $0 } ?? []
        
        return Group {
            VStack(alignment: .trailing, spacing: 4) {  // Right alignment
                Text(userMatch.turnLastTakenDate != nil ? formatDate(userMatch.turnLastTakenDate!) : "No turns taken")
                    .font(.headline)
                    .foregroundColor(.primary)
                // Text("Phase " + String(userMatch.match.phase ?? 0))
                Text(userNamesArray.joined(separator: ", "))
                 //   .font(.callout)
                    .foregroundColor(.white)
                Text(userMatch.turnLastTakenDate != nil ? formatDate(userMatch.turnLastTakenDate!) : "No turns taken")
                  //  .font(.callout)
                    .foregroundColor(.white)
            }
        }
    }
}
