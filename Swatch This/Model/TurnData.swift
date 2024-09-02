//
//  TurnData.swift
//  Swatch This
//
//  Created by Russ Hooper on 8/1/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import Foundation

final class TurnData: ObservableObject {

    @Published var turnArray = [0, 0]    // turn, roundsFinished
    // unlike the copy in GameData, this is published each time it's updated, driving the game forward
    // GameData is what's sent via Game Center as a way to make sure we're starting at the right spot
    
    var swatchAngles: [Double] = [-5.0, 4.0, -3.0]
    
    var showingTransition = false

}
