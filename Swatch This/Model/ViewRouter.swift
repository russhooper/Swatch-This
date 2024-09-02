//
//  ViewRouter.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/22/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    
    private static let _singleton = ViewRouter()
    public class var sharedInstance: ViewRouter {
        return ViewRouter._singleton
    }
    
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var currentPage: String = "menu" {
        didSet {
            withAnimation() {
                objectWillChange.send(self)
            }
        }
    }
    
    
    var playerCount = 2
    
    var onlineGame = false
    
    var penPaper = false
    
    var colorIndices: [Int] = [
        0,
        0,
        0,
        0
    ]
    
    //  var currentMatch = "NULL"
    
    var inOtherPlayersTurn = false
    
    var playLaunchAnimation = true
    
    var localRematch = false    // gets set to true when Rematch button is pressed at end of Pass & Play. Then gets reset back to false after correctly processed in SwitcherView
    
    
}
