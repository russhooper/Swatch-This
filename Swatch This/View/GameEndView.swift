//
//  GameEndView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/18/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics
import StoreKit

struct GameEndView: View {
    
    var gameData: GameData
    var turnData: TurnData
    @State var selection: String?
    
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var engine: CHHapticEngine?
    
    @EnvironmentObject var transitionSwatches: TransitionSwatches
    
    
    @State private var showConfetti = false
    @State private var showQuit = false
    
    @State private var animate1 = false  // for animating swatches for more info
    @State private var animate2 = false
    @State private var animate3 = false
    @State private var animate4 = false
    
    
    // for game end animation. Swatches start on screen and then disappear one by one
    @State var opacity0: Double = 1
    @State var opacity1: Double = 1
    @State var opacity2: Double = 1
    @State var opacity3: Double = 1
    @State var opacity4: Double = 1
    @State var opacity5: Double = 1
    @State var opacity6: Double = 1
    @State var opacity7: Double = 1
    
    @State var showTransition = true
    
        
    
    var body: some View {
        
        if  horizontalSizeClass == .compact {
            
            NavigationView {
                
                
                ZStack {
                    
                    Color.primaryTeal
                        .edgesIgnoringSafeArea(.all)
                        .onAppear(perform: {
                            
                            prepareHaptics()
                            
                            // save in UserDefaults (checks if we need to save it. If we do also saves lifetime points, lifetime games won, lifetime fooled)
                            GameBrain().saveMatchToHistory(gameData: self.gameData)
                        })
                    
                    GeometryReader(content: geometricView(with:))
                }
            }
            
            
            
            
        } else {
            
            
            GeometryReader(content: geometricViewCustom(with:))
                .onAppear(perform: {
                    
                    prepareHaptics()
                    
                    // save in UserDefaults (checks if we need to save it. If we do also saves lifetime points, lifetime games won, lifetime fooled)
                    GameBrain().saveMatchToHistory(gameData: self.gameData)
                })
        }
        
        
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        
        var fontSize = 23
        
        let titleText = "\(self.gameData.displayNames[self.gameData.sortedPlayersArray[0]]!) is the master \(colorLocalized)smith!"
        
        if titleText.count > 45 {
            fontSize = 18
        }
        
        if self.gameData.onlineGame == false || turnData.showingTransition == true {
            // Pass & Play games don't have multiple players individually coming in to GameEnd
            // The last player in an online match will see the transition already, so we don't want to show it here
            turnData.showingTransition = false // reset
            self.showTransition = false
        }
        
        
        return Group {
            
            ZStack {
                ZStack {
                    
                    if  self.viewRouter.onlineGame == true {
                        
                        if  self.gameData.displayNames[self.gameData.sortedPlayersArray[0]] == GameKitHelper.sharedInstance.getLocalUserName() {
                            
                            if self.turnData.showingTransition == false {
                                
                                
                                SASuperConfettiSwiftUIView(startSuperConfettiBurst: true,
                                                           confettiFrame: CGRect(x: 0, y: 0, width: 400, height: geoHeight))
                                    .edgesIgnoringSafeArea(.all)
                                
                            }
                            // I hardcoded the width to 400. I did this because the geometry.size.width doesn't get set in time for this -- possibly because it's in a navigation view? It's not because the view has the animation at the bottom of the code. The geometry.size.height doesn't seem to care.
                            
                            //   .background(Color.black)
                            //   }
                            
                            
                        }
                    }
                    
                    VStack {
                        
                        Spacer()
                            .frame(height: 20)
                        
                        
                        HStack {
                            
                            
                            Button(action: {
                                
                                self.mildHaptics()
                                
                                self.animate1.toggle()
                                self.animate2 = false
                                self.animate3 = false
                                self.animate4 = false
                                
                                print("animate")
                            }) {
                                SwatchView(colorIndices: self.gameData.colorIndices,
                                           colorAtIndex: 0,
                                           swatchHeight: self.animate1 ? geometry.size.width/1.8 : geoWidth/3.8,
                                           colorName: GameBrain().getColorName(turn: 0, indexArray: self.gameData.colorIndices),
                                           company: GameBrain().getColorCompany(turn: 0, indexArray: self.gameData.colorIndices),
                                           colorURL: GameBrain().getColorURL(turn: 0, indexArray: self.gameData.colorIndices),
                                           coverOpacity: self.animate1 ? 0.0 : 1.0,
                                           logoOpacity: self.animate1 ? 0.5 : 0.0,
                                           nameOpacity: self.animate1 ? 1.0 : 0.0,
                                           fontSize: self.animate1 ? 18 : 6)
                                    .rotationEffect(.degrees(self.animate1 ? 0 : -6))
                            }
                            
                            Button(action: {
                                
                                self.mildHaptics()
                                
                                self.animate1 = false
                                self.animate2.toggle()
                                self.animate3 = false
                                self.animate4 = false
                                
                                print("animate")
                            }) {
                                SwatchView(colorIndices: self.gameData.colorIndices,
                                           colorAtIndex: 1,
                                           swatchHeight: self.animate2 ? geoWidth/1.8 : geoWidth/3.8,
                                           colorName: GameBrain().getColorName(turn: 1, indexArray: self.gameData.colorIndices),
                                           company: GameBrain().getColorCompany(turn: 1, indexArray: self.gameData.colorIndices),
                                           colorURL: GameBrain().getColorURL(turn: 1, indexArray: self.gameData.colorIndices),
                                           coverOpacity: self.animate2 ? 0.0 : 1.0,
                                           logoOpacity: self.animate2 ? 0.5 : 0.0,
                                           nameOpacity: self.animate2 ? 1.0 : 0.0,
                                           fontSize: self.animate2 ? 18 : 6)
                                    .rotationEffect(.degrees(0))
                            }
                        }
                        
                        HStack {
                            
                            Button(action: {
                                
                                self.mildHaptics()
                                
                                self.animate1 = false
                                self.animate2 = false
                                self.animate3.toggle()
                                self.animate4 = false
                                
                                print("animate")
                            }) {
                                SwatchView(colorIndices: self.gameData.colorIndices,
                                           colorAtIndex: 2,
                                           swatchHeight: self.animate3 ? geoWidth/1.8 : geoWidth/3.8,
                                           colorName: GameBrain().getColorName(turn: 2, indexArray: self.gameData.colorIndices),
                                           company: GameBrain().getColorCompany(turn: 2, indexArray: self.gameData.colorIndices),
                                           colorURL: GameBrain().getColorURL(turn: 2, indexArray: self.gameData.colorIndices),
                                           coverOpacity: self.animate3 ? 0.0 : 1.0,
                                           logoOpacity: self.animate3 ? 0.5 : 0.0,
                                           nameOpacity: self.animate3 ? 1.0 : 0.0,
                                           fontSize: self.animate3 ? 18 : 6)
                                    .rotationEffect(.degrees(self.animate3 ? 0 : -3))
                            }
                            
                            Button(action: {
                                
                                self.mildHaptics()
                                
                                self.animate1 = false
                                self.animate2 = false
                                self.animate3 = false
                                self.animate4.toggle()
                                
                                print("animate")
                            }) {
                                SwatchView(colorIndices: self.gameData.colorIndices,
                                           colorAtIndex: 3,
                                           swatchHeight: self.animate4 ? geoWidth/1.8 : geoWidth/3.8,
                                           colorName: GameBrain().getColorName(turn: 3, indexArray: self.gameData.colorIndices),
                                           company: GameBrain().getColorCompany(turn: 3, indexArray: self.gameData.colorIndices),
                                           colorURL: GameBrain().getColorURL(turn: 3, indexArray: self.gameData.colorIndices),
                                           coverOpacity: self.animate4 ? 0.0 : 1.0,
                                           logoOpacity: self.animate4 ? 0.5 : 0.0,
                                           nameOpacity: self.animate4 ? 1.0 : 0.0,
                                           fontSize: self.animate4 ? 18 : 6)
                                    .rotationEffect(.degrees(self.animate4 ? 0 : 5))
                            }
                        }
                        //  .padding(.bottom)
                        
                        
                        Spacer()
                        
                        
                        if self.gameData.finalPointsArray[0] == self.gameData.finalPointsArray[1] {
                            
                            Text("We have a tie!")
                                .font(.system(size: 23))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            //  .frame(width: 250, alignment: .center)
                                .padding()
                            
                            
                        } else {
                            
                            Text(titleText)
                                .font(.system(size: CGFloat(fontSize)))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            // .frame(width: max(geometry.size.width-20, 250), alignment: .center)
                                .padding()
                            
                        }
                        
                        //  present a list of the players ranked by points scored
                        List(self.gameData.sortedPlayersArray, id: \.self) { sortedPlayer in
                            
                            NavigationLink(
                                destination: ScoreDetailView(gameData: self.gameData, playerString: sortedPlayer, onlineGame: self.viewRouter.onlineGame, customSplitView: false), tag: sortedPlayer, selection: self.$selection) {
                                    
                                    
                                    HStack {
                                        
                                        // player
                                        Text(self.gameData.displayNames[sortedPlayer] ?? sortedPlayer)
                                        
                                        
                                        Spacer()
                                        
                                        // points
                                        Text("Points: \(self.gameData.players[sortedPlayer]!)")
                                        
                                    }
                                }
                            
                            
                            
                        }
                        .frame(minWidth: geometry.size.width/3)
                    }
                    .animation(Animation.easeOut(duration: 0.3))
                    
                    
                    if self.viewRouter.onlineGame == false {   // online matches are saved so we don't need to ask about quitting in that case
                        
                        quitView(swatchHeight: geometry.size.width/1.3)
                        // .offset(x: self.showQuit ? 0 : -1*geoWidth, y: 0)
                            .opacity(self.showQuit ? 1 : 0)
                            .animation(.linear(duration: 0.25))
                        
                    }
                    
                    
                    
                    
                }
                
                .navigationTitle("Scores")
                .navigationBarTitleDisplayMode(.inline)
                .background(NavigationConfigurator { nc in
                    // nc.navigationBar.barTintColor = .white
                    //  nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                    
                    
                    
                })
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        Button(action: {
                            
                            self.mildHaptics2()
                            
                            // only show alert for a local match -- online matches can be returned to
                            if self.viewRouter.onlineGame == false {
                                self.showQuit = true
                            }
                            
                            else {
                                self.viewRouter.currentPage = "menu"
                                GameBrain().considerShowingReviewPrompt()
                            }
                            
                        }) {
                            
                            Text("Done")
                            // .font(.system(size: 20))
                                .bold()
                            
                            
                            
                        }
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        if self.viewRouter.onlineGame == true {
                            
                            Button(action: {
                                
                                self.mildHaptics2()
                                
                                
                                GameKitHelper.sharedInstance.rematch() { error in
                                    
                                    if let e = error {
                                        print("Error in rematch: \(e.localizedDescription)")
                                        
                                        NotificationCenter.default.post(name: .gameCenterAlert, object: nil)
                                        
                                        return
                                    } else {
                                        
                                        
                                        if GameKitHelper.sharedInstance.gameCenterEnabled == true {
                                            
                                            self.viewRouter.onlineGame = true
                                            
                                            
                                        } else {
                                            
                                            NotificationCenter.default.post(name: .gameCenterAlert, object: nil)
                                            
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                            }) {
                                Text("Rematch")
                                //  .font(.system(size: 20))
                                    .bold()
                            }
                            
                        }
                    }
                }
                
                
                .accentColor(Color.tangerineText)

                
                // show the iPad's transition view if coming here not as last player, starting as the swatches filling the screen. Yes, the iPad's, for simplicity. The iPhone's transition actually occurs in GuessColorsView
                if showTransition == true {
                    gameEndTransitionViewLarge(geoWidth: geoWidth, geoHeight: geoHeight)
                        .onAppear {
                            
                            // set all transition swatches to opacity = 1 so they can transition out
                            self.transitionSwatches.updateFrame(geoWidth: geoWidth, geoHeight: geoHeight)
                            
                            for swatch in self.transitionSwatches.swatches {
                                self.transitionSwatches.updateOpacity(id: swatch, opacity: 1)
                            }
                        }
                    
                }
                
                
            }
            
        }
    }
    
    
    
    
    
    
    // for the iPad's larger area
    func geometricViewCustom(with geometry: GeometryProxy) -> some View {
        
        let geoWidth50 = geometry.size.width/2
        
        
        var fontSize = 25
        
        let titleText = "\(self.gameData.displayNames[self.gameData.sortedPlayersArray[0]]!) is the master \(colorLocalized)smith!"
        
        if titleText.count > 45 {
            fontSize = 20
        }
        
        
        return Group {
            
            ZStack {
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        Color.mercury
                            .edgesIgnoringSafeArea(.all)
                        
                        HStack {
                            
                            Button(action: {
                                
                                self.mildHaptics2()
                                
                                // only show alert for a local match -- online matches can be returned to
                                if self.viewRouter.onlineGame == false {
                                    self.showQuit = true
                                }
                                
                                else {
                                    self.viewRouter.currentPage = "menu"
                                    GameBrain().considerShowingReviewPrompt()
                                }
                                
                            }) {
                                Text("Done")
                                    .font(.system(size: 18))
                                    .bold()
                            }
                            .padding()
                            
                            
                            Spacer()
                            
                            if self.viewRouter.onlineGame == true {
                                
                                Button(action: {
                                    
                                    self.mildHaptics2()
                                    
                                    
                                    GameKitHelper.sharedInstance.rematch() { error in
                                        
                                        if let e = error {
                                            print("Error in rematch: \(e.localizedDescription)")
                                            
                                            NotificationCenter.default.post(name: .gameCenterAlert, object: nil)
                                            
                                            return
                                        } else {
                                            
                                            
                                            if GameKitHelper.sharedInstance.gameCenterEnabled == true {
                                                
                                                self.viewRouter.onlineGame = true
                                                
                                                
                                            } else {
                                                
                                                NotificationCenter.default.post(name: .gameCenterAlert, object: nil)
                                                
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }) {
                                    Text("Rematch")
                                        .font(.system(size: 18))
                                        .bold()
                                }
                                .padding()
                                
                            }
                        }
                    }
                    .frame(height: 40)
                    
                    
                    
                    
                    
                    ZStack {
                        HStack(spacing: 0) {
                            
                            // left half of screen
                            ZStack {
                                
                                Color.primaryTeal
                                    .edgesIgnoringSafeArea(.all)
                                    .onAppear(perform: prepareHaptics)
                                
                                if  self.viewRouter.onlineGame == true {
                                    
                                    if  self.gameData.displayNames[self.gameData.sortedPlayersArray[0]] == GameKitHelper.sharedInstance.getLocalUserName() {
                                        
                                        if showTransition == false {    // the transition has already finished playing
                                            
                                            SASuperConfettiSwiftUIView(startSuperConfettiBurst: true,
                                                                       confettiFrame: CGRect(x: 0, y: 0, width: 400, height: geometry.size.height))
                                                .edgesIgnoringSafeArea(.all)
                                            
                                            
                                            // I hardcoded the width to 400. I did this because the geometry.size.width doesn't get set in time for this -- possibly because it's in a navigation view? It's not because the view has the animation at the bottom of the code. The geometry.size.height doesn't seem to care.
                                            
                                            //   .background(Color.black)
                                            
                                        }
                                    }
                                }
                                
                                VStack {
                                    
                                    Spacer()
                                        .frame(height: 20)
                                    
                                    
                                    HStack {
                                        
                                        Button(action: {
                                            
                                            self.mildHaptics()
                                            
                                            self.animate1.toggle()
                                            self.animate2 = false
                                            self.animate3 = false
                                            self.animate4 = false
                                            
                                            print("animate")
                                        }) {
                                            SwatchView(colorIndices: self.gameData.colorIndices,
                                                       colorAtIndex: 0,
                                                       swatchHeight: self.animate1 ? geoWidth50/2.1 : geoWidth50/3.8,
                                                       colorName: GameBrain().getColorName(turn: 0, indexArray: self.gameData.colorIndices),
                                                       company: GameBrain().getColorCompany(turn: 0, indexArray: self.gameData.colorIndices),
                                                       colorURL: GameBrain().getColorURL(turn: 0, indexArray: self.gameData.colorIndices),
                                                       coverOpacity: self.animate1 ? 0.0 : 1.0,
                                                       logoOpacity: self.animate1 ? 0.5 : 0.0,
                                                       nameOpacity: self.animate1 ? 1.0 : 0.0,
                                                       fontSize: self.animate1 ? 18 : 6)
                                                .rotationEffect(.degrees(self.animate1 ? 0 : -6))
                                        }
                                        
                                        Button(action: {
                                            
                                            self.mildHaptics()
                                            
                                            self.animate1 = false
                                            self.animate2.toggle()
                                            self.animate3 = false
                                            self.animate4 = false
                                            
                                            print("animate")
                                        }) {
                                            SwatchView(colorIndices: self.gameData.colorIndices,
                                                       colorAtIndex: 1,
                                                       swatchHeight: self.animate2 ? geoWidth50/2.1 : geoWidth50/3.8,
                                                       colorName: GameBrain().getColorName(turn: 1, indexArray: self.gameData.colorIndices),
                                                       company: GameBrain().getColorCompany(turn: 1, indexArray: self.gameData.colorIndices),
                                                       colorURL: GameBrain().getColorURL(turn: 1, indexArray: self.gameData.colorIndices),
                                                       coverOpacity: self.animate2 ? 0.0 : 1.0,
                                                       logoOpacity: self.animate2 ? 0.5 : 0.0,
                                                       nameOpacity: self.animate2 ? 1.0 : 0.0,
                                                       fontSize: self.animate2 ? 18 : 6)
                                                .rotationEffect(.degrees(0))
                                        }
                                    }
                                    
                                    HStack {
                                        
                                        Button(action: {
                                            
                                            self.mildHaptics()
                                            
                                            self.animate1 = false
                                            self.animate2 = false
                                            self.animate3.toggle()
                                            self.animate4 = false
                                            
                                            print("animate")
                                        }) {
                                            SwatchView(colorIndices: self.gameData.colorIndices,
                                                       colorAtIndex: 2,
                                                       swatchHeight: self.animate3 ? geoWidth50/2.1 : geoWidth50/3.8,
                                                       colorName: GameBrain().getColorName(turn: 2, indexArray: self.gameData.colorIndices),
                                                       company: GameBrain().getColorCompany(turn: 2, indexArray: self.gameData.colorIndices),
                                                       colorURL: GameBrain().getColorURL(turn: 2, indexArray: self.gameData.colorIndices),
                                                       coverOpacity: self.animate3 ? 0.0 : 1.0,
                                                       logoOpacity: self.animate3 ? 0.5 : 0.0,
                                                       nameOpacity: self.animate3 ? 1.0 : 0.0,
                                                       fontSize: self.animate3 ? 18 : 6)
                                                .rotationEffect(.degrees(self.animate3 ? 0 : -3))
                                        }
                                        
                                        Button(action: {
                                            
                                            self.mildHaptics()
                                            
                                            self.animate1 = false
                                            self.animate2 = false
                                            self.animate3 = false
                                            self.animate4.toggle()
                                            
                                            print("animate")
                                        }) {
                                            SwatchView(colorIndices: self.gameData.colorIndices,
                                                       colorAtIndex: 3,
                                                       swatchHeight: self.animate4 ? geoWidth50/2.1 : geoWidth50/3.8,
                                                       colorName: GameBrain().getColorName(turn: 3, indexArray: self.gameData.colorIndices),
                                                       company: GameBrain().getColorCompany(turn: 3, indexArray: self.gameData.colorIndices),
                                                       colorURL: GameBrain().getColorURL(turn: 3, indexArray: self.gameData.colorIndices),
                                                       coverOpacity: self.animate4 ? 0.0 : 1.0,
                                                       logoOpacity: self.animate4 ? 0.5 : 0.0,
                                                       nameOpacity: self.animate4 ? 1.0 : 0.0,
                                                       fontSize: self.animate4 ? 18 : 6)
                                                .rotationEffect(.degrees(self.animate4 ? 0 : 5))
                                        }
                                    }
                                    .padding()
                                    
                                    
                                    Spacer()
                                    
                                    
                                    if self.gameData.finalPointsArray[0] == self.gameData.finalPointsArray[1] {
                                        
                                        Text("We have a tie!")
                                            .font(.system(size: 25))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                        //   .frame(width: 250, alignment: .center)
                                            .padding()
                                        
                                        
                                    } else {
                                        
                                        
                                        Text(titleText)
                                            .font(.system(size: CGFloat(fontSize)))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                        //    .frame(width: max(geoWidth50-20, 200), alignment: .center)
                                            .padding()
                                        
                                    }
                                    
                                    
                                    //  present a list of the players ranked by points scored
                                    List(self.gameData.sortedPlayersArray, id: \.self) { sortedPlayer in
                                        
                                        
                                        Button(action: {
                                            
                                            self.selection = sortedPlayer
                                            
                                        }) {
                                            HStack {
                                                
                                                // player
                                                
                                                
                                                // player
                                                Text(self.gameData.displayNames[sortedPlayer] ?? sortedPlayer)
                                                
                                                
                                                
                                                Spacer()
                                                
                                                // points
                                                
                                                Text("Points: \(self.gameData.players[sortedPlayer]!)")
                                                    .foregroundColor(.black)
                                                    .padding()
                                                
                                                if sortedPlayer == self.selection {
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .accentColor(Color.tangerineText)
                                                    //     .bold()
                                                        .font(Font.system(size: 20, weight: .bold))
                                                    
                                                } else {
                                                    
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(.gray)
                                                        .font(Font.system(size: 20, weight: .regular))
                                                }
                                                
                                                
                                                
                                            }
                                        }
                                    }
                                    .frame(width: geoWidth50-20)
                                    .cornerRadius(5)
                                    
                                    
                                }
                            }
                            .frame(width: geoWidth50)
                            
                            // right half of screen
                            ZStack {
                                
                                Color(.white)
                                    .edgesIgnoringSafeArea(.all)
                                
                                ScoreDetailView(gameData: self.gameData, playerString: self.selection ?? self.gameData.sortedPlayersArray[0], onlineGame: self.viewRouter.onlineGame, customSplitView: true)
                                
                            }
                            .frame(width: geoWidth50)
                            
                        }
                        .accentColor(Color.tangerineText)
                        .animation(Animation.easeOut(duration: 0.3))
                        
                        if self.viewRouter.onlineGame == false {   // online matches are saved so we don't need to ask about quitting in that case
                            
                            quitView(swatchHeight: geoWidth50/1.3)
                            // .offset(x: self.showQuit ? 0 : -1*geoWidth, y: 0)
                                .opacity(self.showQuit ? 1 : 0)
                                .animation(.linear(duration: 0.25))
                            
                        }
                        
                    }
                    
                }
                
                
                if showTransition == true {
                    gameEndTransitionViewLarge(geoWidth: geometry.size.width, geoHeight: geometry.size.height)
                        .onAppear {
                            
                            if self.gameData.onlineGame == true && self.turnData.showingTransition == false {   // if showingTransition == true, then the swatches have already had their frames updated
                                
                                // set all transition swatches to opacity = 1 so they can transition out
                                self.transitionSwatches.updateFrame(geoWidth: geometry.size.width, geoHeight: geometry.size.height)
                                
                                for swatch in self.transitionSwatches.swatches {
                                    self.transitionSwatches.updateOpacity(id: swatch, opacity: 1)
                                }
                            }
                            
                        }
                    
                }
                
            }
            
        }
    }
    
    
    
    
    func gameEndTransitionViewLarge(geoWidth: CGFloat, geoHeight: CGFloat) -> some View {
        
        var swatchHeight: CGFloat = 370
        
        if geoWidth > geoHeight {
            swatchHeight = min(max(geoHeight * 0.6, 250), 390)
        } else {
            swatchHeight = min(max(geoWidth * 0.75, 250), 370)
        }
        
        
        return Group {
            
            
            ZStack {
                
                ForEach(self.transitionSwatches.swatches) { swatch in
                    
                    SwatchStackView(swatchColor: Color(hex: GameBrain().getColorHex(turn: swatch.turn,
                                                                 indexArray: self.gameData.colorIndices)),
                                    swatchHeight: swatchHeight,
                                    text: "",
                                    textField: nil,
                                    subtext: "",
                                    fontSize: 10,
                                    inGame: false,
                                    turnNumber: 0)
                        .rotationEffect(.degrees(swatch.rotation))
                        .offset(x: swatch.offsetX, y: swatch.offsetY)
                        .opacity(swatch.opacity)    // swatch.opacity should have already been set to 1 by GuessColorsView
                        .onAppear {
                            
                            if (swatch.id == self.transitionSwatches.swatches.count-1) {
                                
                                var index = 0
                                
                                for reverseSwatch in self.transitionSwatches.swatches.reversed() {
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(index)/30) {
                                        
                                        self.transitionSwatches.updateOpacity(id: reverseSwatch, opacity: 0)
                                        
                                        
                                        
                                    }
                                    
                                    index = index + 1
                                    
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(0.9)) {   // why does TimeInterval(self.transitionSwatches.swatches.count)/30 not work?
                                    
                                    self.showTransition = false
                                    turnData.showingTransition = false // reset
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                }
                
            }
            .frame(maxWidth: geoWidth)  // if we don't have this it expands the width and shifts other parts of the view
            .edgesIgnoringSafeArea(.all)
            
            
        }
    }
    
    
    func quitView(swatchHeight: CGFloat) -> some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.75),
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
                        .foregroundColor(Color.primaryTeal)
                    
                    
                    Button(action: {
                        
                        self.mildHaptics2()
                        self.viewRouter.currentPage = "menu"
                        GameBrain().considerShowingReviewPrompt()
                        
                        
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
    
    func strongHaptics() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
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
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}



/*
 struct GameEndView_Previews: PreviewProvider {
 static var previews: some View {
 GameEndView()
 }
 }
 */

