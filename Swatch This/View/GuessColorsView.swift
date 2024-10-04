//
//  GuessColorsView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/17/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics


struct GuessColorsView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var gameData: GameData
    var turnData: TurnData
    let playerCount: Int
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var engine: CHHapticEngine?
    
    @EnvironmentObject var transitionSwatches: TransitionSwatches
    
    
    @State private var passToNextPlayer = false
    @State private var isGameEnd = false
    @State private var player = 1
    @State private var showConfetti = false
    @State private var hasGuessed = false
    @State private var paintOffsetX: CGFloat = 0
    @State private var transitionOpacity: CGFloat = 0
    @State private var showQuit = false
    
    let blushColor: UInt32 = 0xf95352
    
    
    
    // for the dealing animation at the begininning
    
    @State private var animationState0: AnimationState = .notAppeared
    @State private var animationState1: AnimationState = .notAppeared
    @State private var animationState2: AnimationState = .notAppeared
    @State private var animationState3: AnimationState = .notAppeared
    
    @State private var hudOpacity: Double = 0
    
    private let dealDuration: TimeInterval = 1
    private let dealDelay0: TimeInterval = 0.6
    private let dealDelay1: TimeInterval = 0.4
    private let dealDelay2: TimeInterval = 0.2
    private let dealDelay3: TimeInterval = 0
    
    private let flingDuration: TimeInterval = 0.75
    
    
    private var swatchOffset3: CGFloat {
        switch animationState3 {
        case .notAppeared: return -500
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity3: Double {
        switch animationState3 {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset2: CGFloat {
        switch animationState2 {
        case .notAppeared: return -500
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity2: Double {
        switch animationState2 {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset1: CGFloat {
        switch animationState1 {
        case .notAppeared: return -500
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity1: Double {
        switch animationState1 {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset0: CGFloat {
        switch animationState0 {
        case .notAppeared: return -500
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity0: Double {
        switch animationState0 {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    
    // for small device game end animation
    @State var opacity0: Double = 0
    @State var opacity1: Double = 0
    @State var opacity2: Double = 0
    @State var opacity3: Double = 0
    @State var opacity4: Double = 0
    @State var opacity5: Double = 0
    @State var opacity6: Double = 0
    @State var opacity7: Double = 0
    @State var opacity8: Double = 0
    
    @State private var animationState0T: AnimationState = .notAppeared
    @State private var animationState1T: AnimationState = .notAppeared
    @State private var animationState2T: AnimationState = .notAppeared
    @State private var animationState3T: AnimationState = .notAppeared
    @State private var animationState4T: AnimationState = .notAppeared
    @State private var animationState5T: AnimationState = .notAppeared
    @State private var animationState6T: AnimationState = .notAppeared
    
    private let dealDelay0T: TimeInterval = 0
    private let dealDelay1T: TimeInterval = 0.2
    private let dealDelay2T: TimeInterval = 0.4
    private let dealDelay3T: TimeInterval = 0.6
    private let dealDelay4T: TimeInterval = 0.8
    private let dealDelay5T: TimeInterval = 1
    private let dealDelay6T: TimeInterval = 1.2
    
    private var swatchOffset6T: CGFloat {
        switch animationState6T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity6T: Double {
        switch animationState6T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset5T: CGFloat {
        switch animationState5T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity5T: Double {
        switch animationState5T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset4T: CGFloat {
        switch animationState4T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity4T: Double {
        switch animationState4T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset3T: CGFloat {
        switch animationState3T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity3T: Double {
        switch animationState3T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset2T: CGFloat {
        switch animationState2T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity2T: Double {
        switch animationState2T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset1T: CGFloat {
        switch animationState1T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity1T: Double {
        switch animationState1T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    private var swatchOffset0T: CGFloat {
        switch animationState0T {
        case .notAppeared: return 1000
        case .appeared: return 0
        case .flung: return 500
        }
    }
    
    private var swatchOpacity0T: Double {
        switch animationState0T {
        case .notAppeared: return 0
        case .appeared: return 1
        case .flung: return 0
        }
    }
    
    
    
    
    
    var body: some View {
        
        ZStack {
            
            //  Color(red: 221/255, green: 217/255, blue: 211/255, opacity: 1.0)
            Color(brightTealColor)
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: prepareHaptics)
            
            
            GeometryReader(content: geometricView(with:))
            /*
             .onAppear {
             let baseAnimation = Animation.linear(duration: 0.5)
             
             return withAnimation(baseAnimation) {
             self.transitionOpacity = 1
             }
             }
             */
        }
        
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        var swatchHeight: CGFloat = 370
        
        if geoWidth > geoHeight {
            swatchHeight = min(geoHeight * 0.6, 300)
        } else {
            swatchHeight = min(geoWidth * 0.65, 340)
        }
        
        var largeVerticalDevice = false
        
        if horizontalSizeClass == .regular && geoHeight > geoWidth {
            largeVerticalDevice = true
        }
        
        var vStackSpacing: CGFloat = 30
        
        if geoHeight < 670 {
            vStackSpacing = 15
        }
        
        
        
        return Group {
            
            
            ZStack {
                
                
                
                SAConfettiSwiftUIView(startConfettiBurst: self.showConfetti,
                                      confettiFrame: CGRect(x: 0, y: 0, width: geoWidth, height: geometry.size.height))
                    .edgesIgnoringSafeArea(.all)
                // .background(Color.black)
                
                
                
                
                VStack(alignment: .center, spacing: vStackSpacing) {
                    
                    HStack {
                        
                        Button(action: {
                            
                            self.mildHaptics2()
                            
                            // only show alert for a local match -- online matches can be resumed
                            if self.viewRouter.onlineGame == false {
                                self.showQuit = true
                            }
                            
                            else {
                                self.viewRouter.currentPage = "menu"
                            }
                            
                        }) {
                            Text("Quit Game")
                                .font(.system(size: 18))
                                .foregroundColor(self.showQuit ? Color(brightTealColor) : .white)
                                .bold()
                                .animation(.linear(duration: 0.25))
                            
                        }
                        .opacity(self.hudOpacity)
                        .animation(.linear(duration: 0.5).delay(self.turnData.turnArray[0] == 3 ? 0 : 0.5)) // no delay if we're animating out, only for animating in
                        .padding()
                        
                        Spacer()
                    }
                    
                    
                    if largeVerticalDevice == true {
                        Spacer()
                    }
                    
                    
                    ZStack {
                        
                        
                        SwatchStackView(color: gameBrain.getColorHex(turn: 3,
                                                                     indexArray: self.gameData.colorIndices),
                                        swatchHeight: swatchHeight,
                                        text: self.hasGuessed && turnData.turnArray[0] == 3 ? gameBrain.getColorName(turn: 3, indexArray: self.gameData.colorIndices) : "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 18,
                                        inGame: false,
                                        turnNumber: 0)
                            .rotationEffect(self.turnData.turnArray[0] == 3 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[2]))
                            .offset(x: self.swatchOffset3, y: self.animationState3 == .flung ? -40 : 0)
                            .opacity(self.swatchOpacity3)
                            .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))   // controls fling animation
                            .onAppear { // controls deal animation
                                let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                                
                                if gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                                                        playerCount: self.playerCount) == false {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay3) {
                                        return withAnimation(baseAnimation) {
                                            
                                            if animationState3 == .notAppeared {
                                                gameBrain.playDealSoundEffect() // this only plays for the first player, so we call it again later in the passToNextPlayer toggle section
                                            }
                                            
                                            animationState3 = .appeared
                                        }
                                    }
                                    
                                }
                                
                            }
                        
                        SwatchStackView(color: gameBrain.getColorHex(turn: 2,
                                                                     indexArray: self.gameData.colorIndices),
                                        swatchHeight: swatchHeight,
                                        text: self.hasGuessed  && turnData.turnArray[0] == 2 ? gameBrain.getColorName(turn: 2, indexArray: self.gameData.colorIndices) : "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 18,
                                        inGame: false,
                                        turnNumber: 0)
                            .rotationEffect(self.turnData.turnArray[0] == 2 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[1]))
                            .offset(x: self.swatchOffset2, y: self.animationState2 == .flung ? -30 : 0)
                            .opacity(self.swatchOpacity2)
                            .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration))    // controls fling animation
                            .onAppear { // controls deal animation
                                let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration)
                                
                                if gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                                                        playerCount: self.playerCount) == false {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay2) {
                                        return withAnimation(baseAnimation) {
                                            animationState2 = .appeared
                                        }
                                    }
                                }
                                
                            }
                        
                        SwatchStackView(color: gameBrain.getColorHex(turn: 1,
                                                                     indexArray: self.gameData.colorIndices),
                                        swatchHeight: swatchHeight,
                                        text: self.hasGuessed  && turnData.turnArray[0] == 1 ? gameBrain.getColorName(turn: 1, indexArray: self.gameData.colorIndices) : "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 18,
                                        inGame: false,
                                        turnNumber: 0)
                            .rotationEffect(self.turnData.turnArray[0] == 1 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[0]))
                            .offset(x: self.swatchOffset1, y: self.animationState1 == .flung ? -20 : 0)
                            .opacity(self.swatchOpacity1)
                            .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration)) // controls fling animation
                            .onAppear { // controls deal animation
                                let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                                
                                if gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                                                        playerCount: self.playerCount) == false {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay1) {
                                        return withAnimation(baseAnimation) {
                                            animationState1 = .appeared
                                        }
                                    }
                                }
                                
                                
                            }
                        
                        SwatchStackView(color: gameBrain.getColorHex(turn: 0,
                                                                     indexArray: self.gameData.colorIndices),
                                        swatchHeight: swatchHeight,
                                        text: self.hasGuessed  && turnData.turnArray[0] == 0 ? gameBrain.getColorName(turn: 0, indexArray: self.gameData.colorIndices) : "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 18,
                                        inGame: false,
                                        turnNumber: 0)
                            .offset(x: self.swatchOffset0, y: self.animationState0 == .flung ? -10 : 0)
                            .opacity(self.swatchOpacity0)
                            .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration)) // controls fling animation
                            .onAppear { // controls deal animation
                                let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                                
                                if gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                                                        playerCount: self.playerCount) == false {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay0) {
                                        return withAnimation(baseAnimation) {
                                            animationState0 = .appeared
                                            hudOpacity = 1
                                        }
                                    }
                                }
                                
                                
                            }
                        
                        if self.viewRouter.onlineGame == false {   // online game progress is saved so we don't need to ask about quitting in that case
                            
                            quitView(swatchHeight: swatchHeight)
                                // .offset(x: self.showQuit ? 0 : -1*geoWidth, y: 0)
                                .opacity(self.showQuit ? 1 : 0)
                                .animation(.linear(duration: 0.25))
                            
                        }
                        
                        
                    }
                    
                    Spacer()
                    
                    colorsListView(geoWidth: geoWidth, geoHeight: geoHeight, vStackSpacing: vStackSpacing) // also includes the "next" stripe above the list of colors
                    
                }
                
                
                
                if self.isGameEnd == true || gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                                                                 playerCount: self.playerCount) {
                                        
                    if self.horizontalSizeClass == .regular {   // iPad with large dimensions has a different transition animation
                        
                        gameEndTransitionViewLarge(geoWidth: geoWidth, geoHeight: geoHeight)
                        
                        
                    } else {    // iPhone or multitasking iPad
                        gameEndTransitionView(geoWidth: geoWidth)
                    }
                    
                } else if self.passToNextPlayer == true {
                    
                    if self.viewRouter.onlineGame == false {
                        
                        ZStack {
                            
                            Color(brightTealColor)
                                .edgesIgnoringSafeArea(.all)
                            
                            Image("Paint Stripe")
                                .frame(height: 350, alignment: .center)
                                .offset(y: -60)
                            
                            Image("Paint Stripe")
                                .frame(height: 350, alignment: .center)
                                .offset(y: 60)
                            
                            
                            VStack(alignment: .center) {
                                
                                Spacer()
                                
                                
                                Text("Pass device to \(self.gameData.displayNames["Player \(self.gameData.currentPlayer)"] ?? "Player \(self.gameData.currentPlayer)")")
                                    .font(.system(size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(brightTealColor))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 250, alignment: .center)
                                
                                Button(action: {
                                    
                                    self.strongHaptics2()
                                    
                                    self.paintOffsetX = 0
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // to allow time for paint animation
                                        
                                        self.passToNextPlayer.toggle()
                                        
                                        
                                        // play deal animations for next player
                                        
                                        gameBrain.playDealSoundEffect()
                                        
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay3) {
                                            animationState3 = .appeared
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay2) {
                                            animationState2 = .appeared
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay1) {
                                            animationState1 = .appeared
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay0) {
                                            animationState0 = .appeared
                                            hudOpacity = 1
                                        }
                                        
                                    }
                                    
                                    
                                }) {
                                    Text("Start turn")
                                        .font(.system(size: 24))
                                        .bold()
                                        .padding()
                                    
                                }
                                Spacer()
                            }
                            
                            
                            ZStack {
                                
                                Image("Paint Stripe Reveal")
                                    .frame(height: 350, alignment: .center)
                                    .offset(y: -60)
                                
                                Image("Paint Stripe Reveal")
                                    .frame(height: 350, alignment: .center)
                                    .offset(y: 60)
                            }
                            
                            .offset(x: self.paintOffsetX)
                            .animation(.linear(duration: 0.5))
                            .onAppear {
                                let baseAnimation = Animation.linear(duration: 0.5)
                                
                                return withAnimation(baseAnimation) {
                                    self.paintOffsetX = 1700
                                }
                            }
                            
                        }
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                    } else {
                        
                        OtherPlayersTurn(colorIndices: self.gameData.colorIndices, rotations: gameBrain.generate4Angles())
                            .environmentObject(ViewRouter.sharedInstance)
                         //   .transition(.move(edge: .trailing))

                    }
                }
            }
            .accentColor(Color(DefaultColors.shared.tangerineColorText))
            
        }
    }
    
    
    func processTurn(geoWidth: CGFloat, geoHeight: CGFloat) {
        
        
        // GuessColorsView gets called a lot on iPad due to the transition. This if statement is to protect against progressing the game when it's already game end
        if (gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                                playerCount: self.playerCount) == false) {
            
            self.turnData.turnArray = gameBrain.advanceGame(turnArray: self.turnData.turnArray,
                                                            indexArray: self.gameData.colorIndices,
                                                            playerCount: self.playerCount)
        }
        

        
        //       print("ViewRouter online: \(self.viewRouter.onlineGame)")
        
        
        
        
        
        if (gameBrain.isGameEnd(roundsFinished: self.turnData.turnArray[1],
                               playerCount: self.playerCount) || self.isGameEnd == true) {
            
            if self.horizontalSizeClass == .regular {   // iPad with large dimensions needs to prep its transition animation
                self.transitionSwatches.updateFrame(geoWidth: geoWidth, geoHeight: geoHeight)
            }
            
            self.isGameEnd = true
            
            if self.gameData.currentPlayer < self.playerCount {
                self.gameData.currentPlayer += 1
            } else {
                self.gameData.currentPlayer = 1
            }
            
            self.gameData.turnArray = self.turnData.turnArray
            
            
            if self.viewRouter.onlineGame == true {
                
                // update the displayNames dictionary with usernames so we can show that instead of Player 1, Player 2, etc.
                self.gameData.displayNames = GameKitHelper.sharedInstance.getPlayerUserNames(displayNames: self.gameData.displayNames, sortedPlayersArray: self.gameData.sortedPlayersArray)
                
                // will also save match to history in GameEnd
                gameBrain.endOnlineGame(gameData: self.gameData)
            }
        } else if gameBrain.isPlayerEnd(turnArray: self.turnData.turnArray) {
            
            print("toggle playerEnd")
            
            
            if self.gameData.currentPlayer < self.playerCount {
                self.gameData.currentPlayer += 1
            } else {
                self.gameData.currentPlayer = 1
            }
            
            if self.viewRouter.onlineGame == true {
                
                self.gameData.turnArray = self.turnData.turnArray
                
                if let appVersion = Float(UIApplication.appVersion!) {
                    self.gameData.appVersion = appVersion
                }
                
                gameBrain.endOnlineTurn(gameData: self.gameData)
            }
            
            
            
            self.passToNextPlayer.toggle()
            
            // reset swatches
            animationState0 = .notAppeared
            animationState1 = .notAppeared
            animationState2 = .notAppeared
            animationState3 = .notAppeared
            
            
        }
        
    }
    
    
    func colorsListView(geoWidth: CGFloat, geoHeight: CGFloat, vStackSpacing: CGFloat) -> some View {
        
        var vStackSpacingLocal = vStackSpacing
        var viewWidth = geoWidth
        var largeScreen = false
        
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            largeScreen = true
            vStackSpacingLocal = 0  // no space between "next" ribbon and colors list
            viewWidth = 500
        }
        
        return Group {
            
            ZStack {
                
                VStack(alignment: .center, spacing: vStackSpacingLocal) {
                    
                    ZStack {
                        
                        if largeScreen == true {
                            Rectangle()
                                .frame(width: viewWidth, height: 50, alignment: .center)
                                .foregroundColor(.white)
                                .overlay(Divider().background(Color(brightTealColor)), alignment: .bottom)
                                .cornerRadius(5, corners: [.topLeft, .topRight])
                            
                            
                        } else {
                            Rectangle()
                                .frame(width: viewWidth, height: 50, alignment: .center)
                                .foregroundColor(.white)
                        }
                        
                        
                        if self.hasGuessed == false {
                            
                            Text("Swatch ya think? Which is the actual name?")
                                .font(.system(size: 18))
                                //  .fontWeight(.bold)
                                // .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(height: 50, alignment: .center)
                            //   .padding()
                            
                            
                        } else {
                            
                            Button(action: {
                                
                                self.mildHaptics()
                                gameBrain.playSlideSoundEffect()
                                
                                
                                self.hasGuessed = false
                                self.showConfetti = false
                                
                                // fling the swatch off screen after it's submitted
                                if self.turnData.turnArray[0] == 0 { animationState0 = .flung }
                                if self.turnData.turnArray[0] == 1 { animationState1 = .flung }
                                if self.turnData.turnArray[0] == 2 { animationState2 = .flung }
                                if self.turnData.turnArray[0] == 3 {
                                    
                                    animationState3 = .flung
                                    hudOpacity = 0
                                    
                                }
                                
                                if self.turnData.turnArray[0] == 3 {    // we need a delay for the last turn, to allow its swatch to be flung before the turn moves on
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.flingDuration) { // to allow time for last swatch fling animation
                                        processTurn(geoWidth: geoWidth, geoHeight: geoHeight)
                                    }
                                    
                                } else {
                                    
                                    processTurn(geoWidth: geoWidth, geoHeight: geoHeight)
                                    
                                }
                                
                                
                                
                            }) {
                                Text("Next")
                                    .bold()
                                    .font(.system(size: 24))
                                    .frame(height: 50, alignment: .center)
                                // .padding()
                                
                            }
                        }
                    }
                    
                    //  present a list of the submitted color names, including the real one, in alphabetical order
                    List(self.gameData.submittedColorNames[self.turnData.turnArray[0]].sorted(), id: \.self) { string in
                        
                        if gameBrain.isPlayersOwnColor(playersByRound: self.gameData.playersByRound,
                                                       turn: self.turnData.turnArray[0],
                                                       currentPlayer: self.gameData.currentPlayer,
                                                       colorName: string) {
                            // the player's own submission
                            /*
                             if self.horizontalSizeClass == .regular {
                             Text(string)
                             .frame(maxWidth: .infinity, alignment: .center)
                             } else {
                             */
                            Text(string)
                            //   }
                            
                        } else {
                            
                            
                            Button(action: {
                                
                                
                                //   print("\(string) pressed")
                                
                                //  print("Submissions: \(self.gameData.submissionsByPlayer)")
                                //   print("Player \(self.gameData.currentPlayer)")
                                
                                if  self.hasGuessed == false {
                                    
                                    
                                    let correctGuess = gameBrain.checkAnswer(turn: self.turnData.turnArray[0], colorGuessed: string, colorIndices: self.gameData.colorIndices)
                                    //  print("Correct: \(correctGuess)")
                                    
                                    if  correctGuess == true {
                                        
                                        self.correctGuessHaptics()
                                        
                                        gameBrain.playCorrectSoundEffect()

                                        
                                        // give this player points!
                                        self.gameData.players["Player \(self.gameData.currentPlayer)"]! += gameBrain.calculateCorrectGuessPoints(numberOfPlayers: self.gameData.players.count)
                                        
                                        self.showConfetti = true
                                        
                                        
                                        
                                        //    print("\(self.gameData.currentPlayer): \(self.gameData.players["Player \(self.gameData.currentPlayer)"]!)")
                                    } else {
                                        
                                        self.incorrectGuessHaptics()
                                        
                                        self.showConfetti = false
                                        
                                        
                                        // give points to the player that created that name
                                        if (self.gameData.submissionsByPlayer[string] != nil) {
                                            self.gameData.players[self.gameData.submissionsByPlayer[string]!]! += 15
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    // playersByRound[what turn are we on?][what player is this? (considering arrays start at 0)][get "Guessed" key] = set to guessed color name
                                    self.gameData.playersByRound[self.turnData.turnArray[0]][self.gameData.currentPlayer-1]["Guessed"] = string
                                    
                                    
                                    self.hasGuessed = true
                                    
                                    
                                    // sort the players to have an up-to-date list
                                    self.gameData.sortedPlayersArray = gameBrain.orderPlayersByPoints(playersDict: self.gameData.players)
                                    
                                    
                                    // create the ordered points list
                                    self.gameData.finalPointsArray = gameBrain.createFinalPoints(playersDict: self.gameData.players)
                                    
                                }
                                
                                
                            }) {
                                /*
                                 if self.horizontalSizeClass == .regular {
                                 Text(string)
                                 .foregroundColor(Color(tangerineColorText))
                                 .frame(maxWidth: .infinity, alignment: .center)
                                 } else {
                                 */
                                Text(string)
                                    .foregroundColor(Color(DefaultColors.shared.tangerineColorText))
                                //  }
                            }.disabled(self.hasGuessed)
                        }
                    }
                    
                    
                    
                }
                
                Rectangle()
                    //  .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight+swatchHeight*0.4, alignment: .center)
                    .foregroundColor(Color(brightTealColor))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(self.hudOpacity == 0 ? 1 : 0) // reverse of HUD opacity
                    .animation(.linear(duration: 0.5).delay(self.turnData.turnArray[0] == 3 ? 0 : 0.5)) // no delay if we're animating out, only for animating in
                
                
            }
            .frame(width: viewWidth)
            
            
            
            
            
            
        }
        
    }
    
    
    func gameEndTransitionView(geoWidth: CGFloat) -> some View {
        
        
        let offsetYArray: [CGFloat] = [200, 100, 0, -100, -200, -300, -400]
        
        let rotationArray: [Double] = [-90, -85, -80, -75, -70, -65, -60]
        
        let swatchHeight: CGFloat = geoWidth*1.2
        
        
        turnData.showingTransition = true

        
        return Group {
            
            
            ZStack {
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 0,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[0]))
                    .offset(x: self.swatchOffset0T, y: offsetYArray[0])
                    .opacity(self.swatchOpacity0T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay0T) {
                            return withAnimation(baseAnimation) {
                                animationState0T = .appeared
                            }
                        }
                    }
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 1,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[1]))
                    .offset(x: self.swatchOffset1T, y: offsetYArray[1])
                    .opacity(self.swatchOpacity1T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay1T) {
                            return withAnimation(baseAnimation) {
                                animationState1T = .appeared
                            }
                        }
                    }
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 2,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[2]))
                    .offset(x: self.swatchOffset2T, y: offsetYArray[2])
                    .opacity(self.swatchOpacity2T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay2T) {
                            return withAnimation(baseAnimation) {
                                animationState2T = .appeared
                            }
                        }
                    }
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 3,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[3]))
                    .offset(x: self.swatchOffset3T, y: offsetYArray[3])
                    .opacity(self.swatchOpacity3T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay3T) {
                            return withAnimation(baseAnimation) {
                                animationState3T = .appeared
                            }
                        }
                    }
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 0,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[4]))
                    .offset(x: self.swatchOffset4T, y: offsetYArray[4])
                    .opacity(self.swatchOpacity4T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay4T) {
                            return withAnimation(baseAnimation) {
                                animationState4T = .appeared
                            }
                        }
                    }
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 1,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[5]))
                    .offset(x: self.swatchOffset5T, y: offsetYArray[5])
                    .opacity(self.swatchOpacity5T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay5T) {
                            return withAnimation(baseAnimation) {
                                animationState5T = .appeared
                            }
                        }
                    }
                
                
                SwatchStackView(color: gameBrain.getColorHex(turn: 2,
                                                             indexArray: self.gameData.colorIndices),
                                swatchHeight: swatchHeight,
                                text: "",
                                textField: nil,
                                subtext: "",
                                fontSize: 10,
                                inGame: false,
                                turnNumber: 0)
                    .rotationEffect(.degrees(rotationArray[6]))
                    .offset(x: self.swatchOffset6T, y: offsetYArray[6])
                    .opacity(self.swatchOpacity6T)
                    .onAppear {
                        let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay6T) {
                            
                            showGameEnd()
                            
                            return withAnimation(baseAnimation) {
                                animationState6T = .appeared
                            }
                        }
                    }
                
                
                
            }
            /*
             .frame(width: geometry.size.width,
             height: geometry.size.height,
             alignment: .center) // this fixes the confusing new iOS 14 SwiftUI alignment behaviors. Alignment here should function as expected.
             */
        }
    }
    
    
    func gameEndTransitionViewLarge(geoWidth: CGFloat, geoHeight: CGFloat) -> some View {
        
        var swatchHeight: CGFloat = 370
        
        if geoWidth > geoHeight {
            swatchHeight = min(max(geoHeight * 0.6, 250), 390)
        } else {
            swatchHeight = min(max(geoWidth * 0.75, 250), 370)
        }
        
        turnData.showingTransition = true

        
        return Group {
            
            
            ZStack {
                
                ForEach(self.transitionSwatches.swatches) { swatch in
                    
                    SwatchStackView(color: gameBrain.getColorHex(turn: swatch.turn,
                                                                 indexArray: self.gameData.colorIndices),
                                    swatchHeight: swatchHeight,
                                    text: "",
                                    textField: nil,
                                    subtext: "",
                                    fontSize: 10,
                                    inGame: false,
                                    turnNumber: 0)
                        .rotationEffect(.degrees(swatch.rotation))
                        .offset(x: swatch.offsetX, y: swatch.offsetY)
                        .opacity(swatch.opacity)
                        .onAppear {
                            let baseAnimation = Animation.linear
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(swatch.id)/12) {
                                return withAnimation(baseAnimation) {
                                    
                                    // this is causing GuessColorsView to reload a bunch of times
                               //     self.transitionSwatches.updateOpacity(id: swatch, opacity: 1)
                                    
                                    self.transitionSwatches.swatches[swatch.id].opacity = 1
                                    
                                    if (swatch.id == self.transitionSwatches.swatches.count-1) {
                                        
                                        showGameEnd()
                                        
                                    }
                                }
                            }
                        }
                }
                
            }
            .frame(maxWidth: geoWidth)  // if we don't have this it expands the width and shifts other parts of the view
            .edgesIgnoringSafeArea(.all)

            
        }
    }
    
   
    
    func showGameEnd() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.gameData.isComplete = true
                        
            self.viewRouter.currentPage = "game"
            
        }
        
    }
    
    
    
    
    func quitView(swatchHeight: CGFloat) -> some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.5),
                        radius: 5,
                        y: 3)
            
            
            VStack {
                
                Text("End game and return to menu?")
                    .multilineTextAlignment(.center)
                    .padding()
                
                
                HStack {
                    
                    Button(action: {
                        
                        self.mildHaptics()
                        self.showQuit = false
                    }) {
                        Text("Cancel")
                            .bold()
                            .padding()
                        
                    }
                    
                    
                    Text("/")
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .foregroundColor(Color(brightTealColor))
                    
                    
                    Button(action: {
                        
                        self.mildHaptics2()
                        self.viewRouter.currentPage = "menu"
                        
                    }) {
                        Text("Quit")
                            .bold()
                            .padding()
                        
                        
                    }
                    
                }
                
                
                
            }
        }
        .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight+swatchHeight*0.4, alignment: .center)
        
        
    }
    
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func incorrectGuessHaptics() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func mildHaptics() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.75)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func mildHaptics2() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func correctGuessHaptics() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func strongHaptics2() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

enum AnimationState {
    case notAppeared, appeared, flung
}

/*
 struct GuessColorsView_Previews: PreviewProvider {
 static var previews: some View {
 GuessColorsView()
 }
 }
 */
