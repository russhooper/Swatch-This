//
//  CreateColorsView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/17/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//


import SwiftUI
import CoreHaptics
import Introspect
//import AVFoundation


prefix operator ⋮
prefix func ⋮(hex:UInt32) -> Color {
    return Color(hex)
}

extension Color {
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}


let hexColor:(UInt32) -> (Color) = {
    return Color($0)
}


struct NameColorsView: View {
    
    @State private var engine: CHHapticEngine?
    
    
    var turnData: TurnData
    
    @State private var passToNextPlayer = false
    @State private var showUsernameToggle = true
    @State private var isSubmissionEnd = false
    @State private var showQuit = false
    
    @State var flipped = false // state variable used to update the card
    
    
    // get passed in from menu
    let playerCount: Int
    //  @Binding var isPresented: Bool
    @State var playDealAnimation: Bool
    
    
    
    // for the dealing animation at the begininning
    @State private var offsetY3: CGFloat = -500.0
    @State private var offsetY2: CGFloat = -600.0
    @State private var offsetY1: CGFloat = -700.0
    @State private var offsetY0: CGFloat = -800.0
    
    @State private var opacity3: Double = 0
    @State private var opacity2: Double = 0
    @State private var opacity1: Double = 0
    @State private var opacity0: Double = 0
    
    @State private var prepLastSwatch = false
    @State private var flingLastSwatch = false

    @State private var paintOffsetX: CGFloat = 0
    
    @State var userColorName: String = ""
    @State private var enteredPlayerName: String = ""
    
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private let dealDuration: TimeInterval = 0.7
    private let dealDelay0: TimeInterval = 0.6
    private let dealDelay1: TimeInterval = 0.4
    private let dealDelay2: TimeInterval = 0.2
    
    private let flingDuration: TimeInterval = 0.75
    
    
    
    
    var body: some View {
        
        ZStack {
            
            //  Color(red: 221/255, green: 217/255, blue: 211/255, opacity: 1.0)
            Color.primaryTeal
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: prepareHaptics)
            
            if  self.playDealAnimation == true {
                GeometryReader(content: geometricDealingView(with:))
                
            } else {
                
                GeometryReader(content: geometricView(with:))

                /*
                
                if horizontalSizeClass == .regular && verticalSizeClass == .regular {   // iPad
                    if self.prepLastSwatch == false {
                        GeometryReader(content: geometricView(with:))
                    } else {
                        GeometryReader(content: geometricFlingEndView(with:))   // we only need to show the flung swatches on iPad
                    }
                } else {
                    GeometryReader(content: geometricView(with:))
                }
               */
            }
            
        }
    }
    
    
    
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        var swatchHeight: CGFloat = 370
        
        
        
        if geoWidth > geoHeight {
            swatchHeight = min(max(geoHeight * 0.6, 250), 390)
        } else {
            swatchHeight = min(max(geoWidth * 0.75, 250), 370)
        }
        
        
        
        var flingOffsetY3: CGFloat = -30
        var flingOffsetY2: CGFloat = -10
        var flingOffsetY1: CGFloat = 10
        var flingOffsetY0: CGFloat = 30
        
        var flingOffsetX3: CGFloat = -1 * geoWidth
        var flingOffsetX2: CGFloat = flingOffsetX3
        var flingOffsetX1: CGFloat = flingOffsetX3
        var flingOffsetX0: CGFloat = flingOffsetX3
        
        //    print("horizontal: \(horizontalSizeClass), vertical: \(verticalSizeClass)")
        
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            // iPad
            
            if geoWidth > geoHeight * 1.2 {   // clearly landscape
                
                flingOffsetY3 = -0.4 * geoHeight
                flingOffsetY2 = 0.4 * geoHeight
                flingOffsetY1 = 0.3 * geoHeight
                flingOffsetY0 = -0.6 * geoHeight
                
                flingOffsetX3 = swatchHeight * -1.5
                flingOffsetX2 = swatchHeight * 1.4
                flingOffsetX1 = swatchHeight * -1.4
                flingOffsetX0 = swatchHeight * 1.5
                
            } else {    // every other dimension
                
                flingOffsetY3 = -0.4 * geoHeight
                flingOffsetY2 = 0.4 * geoHeight
                flingOffsetY1 = 0.3 * geoHeight
                flingOffsetY0 = min(0.6 * geoHeight, 650) * -1
                
                flingOffsetX3 = swatchHeight * -1
                flingOffsetX2 = swatchHeight * 1.4
                flingOffsetX1 = swatchHeight * -1.4
                flingOffsetX0 = geoWidth * 0.4
                
            }
            
            
            
        }
        
        let shouldShowUsernameEntry = GameBrain().shouldShowUsernameEntry(turnData: self.turnData.turnArray,
                                                                        displayNames: MatchData.shared.match.playerDisplayNames,
                                                                        onlineGame: MatchData.shared.onlineGame ?? false,
                                                                        showUsernameToggle: self.showUsernameToggle)
        
        
        //  let shouldShowUsernameEntry = false // for testing
        
        return Group {
            
         //   if self.isSubmissionEnd == false {
                
                
                if shouldShowUsernameEntry == true {
                    // for online games we pull display names from Game Center
                    // so only show the entry field if not online, and bool is true, and first turn of round, and displayName = default
                    
                    // still shows this incorrectly if Quit pressed before first color submitted in each round, but that seems minor
                    
                    submitDisplayName(swatchHeight: swatchHeight, geoWidth: geoWidth, geoHeight: geoHeight)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .accentColor(Color.tangerineText)

                } else {
                    
                    VStack {
                        
                        HStack {
                            
                            Button(action: {
                                
                                self.mildHaptics2()
                                
                                // only show alert for a local match -- online matches can be resumed
                                if self.viewRouter.onlineGame == false {
                                    self.showQuit = true
                                    
                                } else {
                                    
                                    self.viewRouter.currentPage = "menu"
                                    
                                }
                                
                            }) {
                                Text("Quit Game")
                                    .font(.system(size: 18))
                                    .foregroundColor(self.showQuit ? Color.primaryTeal : .white)
                                    .bold()
                                    .animation(.linear(duration: 0.25))

                            }
                            .padding()
                            
                            // .background(Color(red: 255/255, green: 255/255, blue: 255/255, opacity: 0.5))
                            
                            Spacer()
                            
                        }
                        .padding(.bottom, 30) // make sure the Quit Game gets moved up a lot when the keyboard is shown, for looks
                        .opacity(geometry.safeAreaInsets.bottom > 100 ? 0.0 : 1.0) // also animate out
                        .disabled(self.showQuit)
                        
                        
                        Spacer()
                        
                        ZStack {
                            
                            gameSwatchView(turnNumber: 3, swatchHeight: swatchHeight, tag: 3)
                                .padding(.bottom, 80)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .rotationEffect(self.turnData.turnArray[0] == 3 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[2]))
                                .offset(x: self.flingLastSwatch == false ? 0 : flingOffsetX3,
                                        y: self.flingLastSwatch == false ? 0 : flingOffsetY3)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                            
                            
                            gameSwatchView(turnNumber: 2, swatchHeight: swatchHeight, tag: 2)
                                .padding(.bottom, 80)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .rotationEffect(self.turnData.turnArray[0] == 2 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[1]))
                                .offset(x: self.turnData.turnArray[0] < 3 ? 0 : flingOffsetX2,
                                        y: self.turnData.turnArray[0] < 3 ? 0 : flingOffsetY2)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                            
                            
                            gameSwatchView(turnNumber: 1, swatchHeight: swatchHeight, tag: 1)
                                .padding(.bottom, 80)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .rotationEffect(self.turnData.turnArray[0] == 1 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[0]))
                                .offset(x: self.turnData.turnArray[0] < 2 ? 0 : flingOffsetX1,
                                        y: self.turnData.turnArray[0] < 2 ? 0 : flingOffsetY1)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                            
                            
                            gameSwatchView(turnNumber: 0, swatchHeight: swatchHeight, tag: 0)
                                .padding(.bottom, 80)
                                .ignoresSafeArea(.keyboard, edges: .bottom)
                                .rotationEffect(self.turnData.turnArray[0] == 0 ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[2]))
                                .offset(x: self.turnData.turnArray[0] == 0 ? 0 : flingOffsetX0,
                                        y: self.turnData.turnArray[0] == 0 ? 0 : flingOffsetY0)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                            
                            
                            if MatchData.shared.onlineGame == false {   // online game progress is saved so we don't need to ask about quitting in that case
                                
                                quitView(swatchHeight: swatchHeight)
                                    .padding(.bottom, 80)
                                    .ignoresSafeArea(.keyboard, edges: .bottom)
                                  //  .offset(x: self.showQuit ? 0 : -1*geoWidth, y: 0)
                                    .opacity(self.showQuit ? 1 : 0)
                                    .animation(.linear(duration: 0.25))
                                
                            }
                            
                            
                            
                        }
                        
                        Spacer()
                        
                        
                    }
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center) // this fixes the confusing new iOS 14 SwiftUI alignment behaviors. Alignment here should function as expected.
                    .accentColor(Color.tangerineText)

                }
                
                
                
                
          //  }
            
            /*
            if self.passToNextPlayer == true {
                
                
                if MatchData.shared.onlineGame == false {
                    
                    ZStack {
                        
                        Color.primaryTealColor
                            .edgesIgnoringSafeArea(.all)
                        
                        /*
                         Rectangle()
                         .frame(width: 2000, height: 350, alignment: .center)
                         .foregroundColor(.white)
                         .rotationEffect(.degrees(20))
                         */
                        
                        Image("Paint Stripe")
                            .frame(height: 350, alignment: .center)
                            .offset(y: -60)
                        //  .rotationEffect(.degrees(20))
                        
                        Image("Paint Stripe")
                            .frame(height: 350, alignment: .center)
                            .offset(y: 60)
                        //   .rotationEffect(.degrees(20))
                        
                        
                        
                        VStack(alignment: .center) {
                            
                            Spacer()
                            
                            Text("Pass device to \(self.gameData.displayNames["Player \(self.gameData.currentPlayer)"] ?? "Player \(self.gameData.currentPlayer)")")
                                .font(.system(size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(Color.primaryTeal)
                                .multilineTextAlignment(.center)
                                .frame(width: 250, alignment: .center)
                            
                            Button(action: {
                                
                                self.strongHaptics2()
                                
                                self.paintOffsetX = 0
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // to allow time for paint animation
                                    
                                    self.passToNextPlayer.toggle()
                                    
                                    self.showUsernameToggle = true
                                    
                                    if GameBrain().isSubmissionEnd(roundsFinished: self.turnData.turnArray[1],
                                                                 playerCount: self.playerCount) || self.isSubmissionEnd == true {
                                        self.isSubmissionEnd = true
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
             .accentColor(Color.tangerineText)

                    
                } else {
                    
                    OtherPlayersTurn(colorIndices: MatchData.shared.colorIndices, rotations: GameBrain().generate4Angles())
                        .environmentObject(ViewRouter.sharedInstance)
                    //    .transition(.move(edge: .trailing))

                    
                }
            } else if self.isSubmissionEnd == true {
                /*
                GuessColorsView(gameData: self.gameData,
                                turnData: self.turnData,
                                playerCount: self.playerCount,
                                viewRouter: self._viewRouter)
                */
            }
             */
        }
        
        
        
        //  .modifier(AdaptsToKeyboard())
        
        
        
    }
    
    
    func geometricDealingView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        var swatchHeight: CGFloat = 370
        
        if geoWidth > geoHeight {
            swatchHeight = min(max(geoHeight * 0.6, 250), 390)
        } else {
            swatchHeight = min(max(geoWidth * 0.75, 250), 370)
        }
        
        return Group {
            
            
            VStack {
                
                HStack {
                    
                    
                    Text("Quit Game")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                    
                    
                    Spacer()
                    
                }
                .padding(.bottom, 30) // make sure the Quit Game gets moved up a lot when the keyboard is shown, for looks
                .opacity(geometry.safeAreaInsets.bottom > 100 ? 0.0 : 1.0) // also animate out
                
                
                
                Spacer()
                
                ZStack {
                    
                    
                    gameSwatchView(turnNumber: 3, swatchHeight: swatchHeight, tag: 3)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(.degrees(self.turnData.swatchAngles[2]))
                        .offset(x: 0, y: self.offsetY3)
                        .opacity(self.opacity3)
                        .onAppear {
                            
                            GameBrain().playDealSoundEffect()
                            
                            let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                            
                            return withAnimation(baseAnimation) {
                                self.offsetY3 = 0
                                self.opacity3 = 1
                            }
                        }
                    
                    gameSwatchView(turnNumber: 2, swatchHeight: swatchHeight, tag: 2)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(.degrees(self.turnData.swatchAngles[1]))
                        .offset(x: 0, y: self.offsetY2)
                        .opacity(self.opacity2)
                        .onAppear {
                            let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay2) {
                                return withAnimation(baseAnimation) {
                                    self.offsetY2 = 0
                                    self.opacity2 = 1
                                }
                                
                            }
                            
                        }
                    gameSwatchView(turnNumber: 1, swatchHeight: swatchHeight, tag: 1)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(.degrees(self.turnData.swatchAngles[0]))
                        .offset(x: 0, y: self.offsetY1)
                        .opacity(self.opacity1)
                        .onAppear {
                            let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay1) {
                                return withAnimation(baseAnimation) {
                                    self.offsetY1 = 0.0
                                    self.opacity1 = 1
                                }
                                
                            }
                        }
                    gameSwatchView(turnNumber: 0, swatchHeight: swatchHeight, tag: 0)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .offset(x: 0, y: self.offsetY0)
                        .opacity(self.opacity0)
                        .onAppear {
                            let baseAnimation = Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDuration+self.dealDelay0) {
                                
                                self.playDealAnimation = false;
                                
                                // reset the swatches
                                self.offsetY3 = -500.0
                                self.offsetY2 = -600.0
                                self.offsetY1 = -700.0
                                self.offsetY0 = -800.0
                                
                                self.opacity3 = 0
                                self.opacity1 = 0
                                self.opacity2 = 0
                                self.opacity0 = 0
                                
                                print("done dealing")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay0) {
                                return withAnimation(baseAnimation) {
                                    self.offsetY0 = 0.0
                                    self.opacity0 = 1
                                }
                                
                            }
                            
                        }
                }
                
                Spacer()
                
                
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .center) // this fixes the confusing new iOS 14 SwiftUI alignment behaviors. Alignment here should function as expected.
            .accentColor(Color.tangerineText)
        }
        
        
    }
    
    /*
    func geometricFlingEndView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        var swatchHeight: CGFloat = 370
        
        
        if geoWidth > geoHeight {
            swatchHeight = min(max(geoHeight * 0.6, 250), 390)
        } else {
            swatchHeight = min(max(geoWidth * 0.75, 250), 370)
        }
        
        
        
        var flingOffsetY3: CGFloat = 0
        var flingOffsetY2: CGFloat = 0
        var flingOffsetY1: CGFloat = 0
        var flingOffsetY0: CGFloat = 0
        
        var flingOffsetX3: CGFloat = 0
        var flingOffsetX2: CGFloat = flingOffsetX3
        var flingOffsetX1: CGFloat = flingOffsetX3
        var flingOffsetX0: CGFloat = flingOffsetX3
   
        
        if geoWidth > geoHeight * 1.2 {   // clearly landscape
            
            flingOffsetY3 = -0.4 * geoHeight * 1.75
            flingOffsetY2 = 0.4 * geoHeight
            flingOffsetY1 = 0.3 * geoHeight
            flingOffsetY0 = -0.6 * geoHeight
            
            flingOffsetX3 = swatchHeight * -1.5 * 1.75
            flingOffsetX2 = swatchHeight * 1.4
            flingOffsetX1 = swatchHeight * -1.4
            flingOffsetX0 = swatchHeight * 1.5
            
        } else {    // every other dimension
            
            flingOffsetY3 = -0.4 * geoHeight * 1.75
            flingOffsetY2 = 0.4 * geoHeight
            flingOffsetY1 = 0.3 * geoHeight
            flingOffsetY0 = min(0.6 * geoHeight, 650) * -1
            
            flingOffsetX3 = swatchHeight * -1 * 1.75
            flingOffsetX2 = swatchHeight * 1.4
            flingOffsetX1 = swatchHeight * -1.4
            flingOffsetX0 = geoWidth * 0.4
            
        }
            
        
    
        
        return Group {
            
        
            
            
            VStack {
                
                HStack {
                    
                    
                    Text("Quit Game")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                    
                    
                    Spacer()
                    
                }
                .padding(.bottom, 30) // make sure the Quit Game gets moved up a lot when the keyboard is shown, for looks
                .opacity(geometry.safeAreaInsets.bottom > 100 ? 0.0 : 1.0) // also animate out
                
                
                
                Spacer()
                
                ZStack {
                    
                    gameSwatchView(turnNumber: 3, swatchHeight: swatchHeight, tag: 3)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(self.flingLastSwatch == false ? .degrees(0.0) : .degrees(self.turnData.swatchAngles[2]))
                        .offset(x: self.flingLastSwatch == false ? 0 : flingOffsetX3,
                                y: self.flingLastSwatch == false ? 0 : flingOffsetY3)
                       // .opacity(self.flingLastSwatch ? 0 : 1)
                        .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                       
                    gameSwatchView(turnNumber: 2, swatchHeight: swatchHeight, tag: 2)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(.degrees(self.turnData.swatchAngles[1]))
                        .offset(x: self.flingLastSwatch == false ? flingOffsetX2 : flingOffsetX2*1.5,
                                y: self.flingLastSwatch == false ? flingOffsetY2 : flingOffsetY2*1.5)
                      //  .opacity(self.flingLastSwatch ? 0 : 1)
                        .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                    
                    
                    gameSwatchView(turnNumber: 1, swatchHeight: swatchHeight, tag: 1)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(.degrees(self.turnData.swatchAngles[0]))
                        .offset(x: self.flingLastSwatch == false ? flingOffsetX1 : flingOffsetX1*1.5,
                                y: self.flingLastSwatch == false ? flingOffsetY1 : flingOffsetY1*1.5)
                       // .opacity(self.flingLastSwatch ? 0 : 1)
                        .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                    
                    
                    gameSwatchView(turnNumber: 0, swatchHeight: swatchHeight, tag: 0)
                        .padding(.bottom, 80)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .rotationEffect(.degrees(self.turnData.swatchAngles[2]))
                        .offset(x: self.flingLastSwatch == false ? flingOffsetX0 : flingOffsetX0*1.5,
                                y: self.flingLastSwatch == false ? flingOffsetY0 : flingOffsetY0*1.5)
                      //  .opacity(self.flingLastSwatch ? 0 : 1)
                        .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.flingDuration))
                }
                
                Spacer()
                
                
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .center) // this fixes the confusing new iOS 14 SwiftUI alignment behaviors. Alignment here should function as expected.
     .accentColor(Color.tangerineText)
        }
        
        
    }
    */
    
    func submitDisplayName(swatchHeight: CGFloat, geoWidth: CGFloat, geoHeight: CGFloat) -> some View {
        
        
        return Group {
            
            ZStack {
                
                Color.primaryTeal
                    .edgesIgnoringSafeArea(.all)
                
                
                Image("Paint Stripe")
                    .frame(height: 350, alignment: .center)
                    .offset(y: -60)
                //  .rotationEffect(.degrees(20))
                
                Image("Paint Stripe")
                    .frame(height: 350, alignment: .center)
                    .offset(y: 60)
                //  .rotationEffect(.degrees(20))
                
                
                VStack {
                    
                    
                    
                    Spacer()
                    
                    Text("What's your name?")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryTeal)
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                        .padding()
                    
                    
                    TextField("Player \(self.turnData.turnArray[1]+1)", text: $enteredPlayerName)
                        .frame(width: swatchHeight, alignment: .leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        
                        self.strongHaptics2()
                        
                        self.paintOffsetX = 0
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // to allow time for paint animation
                            
                            MatchData.shared.match.playerDisplayNames = GameBrain().updateDisplayName(round: self.turnData.turnArray[1], userName: self.enteredPlayerName, displayNames: MatchData.shared.match.playerDisplayNames)
                            
                            self.showUsernameToggle = false
                            
                            // reset the textfield
                            self.enteredPlayerName = ""
                            
                            self.playDealAnimation = true
                        }
                        
                        
                        
                    }) {
                        Text("Done")
                            .font(.system(size: 24))
                            .bold()
                            .padding()
                    }
                    .disabled(self.enteredPlayerName.count < 1)
                    
                    
                    Spacer()
                    
                    
                }
                
                
                ZStack {
                    
                    Image("Paint Stripe Reveal")
                        .frame(height: 350, alignment: .center)
                        .offset(y: -60)
                    //   .rotationEffect(.degrees(20))
                    
                    Image("Paint Stripe Reveal")
                        .frame(height: 350, alignment: .center)
                        .offset(y: 60)
                    //  .rotationEffect(.degrees(20))
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
            
        }
        
    }
    
    
    func gameSwatchView(turnNumber: Int, swatchHeight: CGFloat, tag: Int) -> some View {
        
        let fontSize: CGFloat = 15
        
        let swatchColor = hexColor(GameBrain().getColorHex(turn: turnNumber,
                                                         indexArray: MatchData.shared.match.colorIndices))
        
        let player = self.turnData.turnArray[1]+1
        
        var createdName = ""
        
        /*
        let count = MatchData.shared.colors[turnNumber].createdNames?.count
        
        if count != nil {
            if count > 1 && count > player { // submittedColorNames will always have at least a placeholder. The second check is for the 4th submission, when the game gets advanced -- this would cause an index out of bounds error. However, we don't actually show the result of that card as the game moves to the next player
                createdName = MatchData.shared.colors[turnNumber].createdNames[player]
            }
        }
*/
        
        
        return Group {
            
            
            VStack {
                
                
                ZStack(alignment: .top) {
                    
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight+swatchHeight*0.4, alignment: .center)
                        .foregroundColor(.white)
                        .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.35),
                                radius: 5,
                                y: 3)
                    
                    
                    VStack(alignment: .leading) {
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: swatchHeight, height: swatchHeight, alignment: .center)
                                .foregroundColor(swatchColor)
                                .padding(EdgeInsets(top: swatchHeight*0.13/2, leading: 0, bottom: 0, trailing: 0))
                            
                            if tag == self.turnData.turnArray[0] {
                                Text("\(turnNumber+1)/4")
                                    .font(.system(size: fontSize+5))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: swatchHeight-30, height: swatchHeight-10, alignment: .bottomTrailing)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                            }
                            
                        }
                        
                        if tag == self.turnData.turnArray[0] {
                            
                            TextField("Name this \(colorLocalized)", text: self.$userColorName)
                                .frame(width: swatchHeight, alignment: .leading)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .fontWeight(.heavy)
                                .disabled(tag == self.turnData.turnArray[0] ? false : true)
                                .background(Color.white)
                                .introspectTextField { textField in
                                    if tag == self.turnData.turnArray[0] && tag > 0 {  // the swatch views have "tag" values that match their turn
                                        textField.becomeFirstResponder()    // make the textField active
                                        // don't do this if it's the first swatch
                                    }
                                }
                            
                        } else {
                            
                            Text(createdName)
                                .font(.system(size: fontSize+5))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(width: swatchHeight, alignment: .leading)
                            
                        }
                        
                        Spacer()
                        
                        if tag == self.turnData.turnArray[0] {
                            
                            Button(action: {
                                
                                self.mildHaptics()
                                GameBrain().playSlideSoundEffect()
                                
                                createdName = self.userColorName
                                
                                if tag == 3 {    // we need a delay for the last turn, to allow its swatch to be flung before the turn moves on
                                    
                                    self.flingLastSwatch = true // this tells the last swatch it should fling
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.flingDuration) { // to allow time for last swatch fling animation
                                        self.turnData.turnArray = GameBrain().processTurn(userColorName: createdName, turnData: turnData, playerCount: playerCount)
                                        self.prepLastSwatch = false
                                        self.flingLastSwatch = false
                                        self.viewRouter.currentPage = "onlineMatchesView"
                                    }
                                    
                                    
                                } else {    // if it's not the last turn we can advance the game immediately
                                    
                                    if tag == 2 && horizontalSizeClass == .regular && verticalSizeClass == .regular {
                                        self.prepLastSwatch = true  // switch the view over to the one ready for the last animation, on iPad
                                    }
                                    
                                    
                                    self.turnData.turnArray = GameBrain().processTurn(userColorName: createdName, turnData: turnData, playerCount: playerCount)
                                    
                                    print("turnArray B: \(turnData.turnArray)")

                                    
                                }
                                
                                // clear the textfield
                                self.userColorName = ""
                                
                                
                                
                            }) {
                                Text("Submit")
                                    .font(.system(size: 20))
                                    .bold()
                            }
                            .disabled(self.userColorName.count < 1 || self.userColorName.containsProfanity())
                        }
                        
                        Spacer()
                        
                    }
                }
            }
            .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight+swatchHeight*0.4)
            
            
        }
        
        
    }
    
    
   
   
   
    
    
    /*
    func submitName(userColorName: String) {
        
        
        // store the submitted color name
        MatchData.shared.submittedColorNames = GameBrain().storeUserColorName(turnArray: self.turnData.turnArray,
                                                                         userColor: userColorName.localizedCapitalized, // capitalize all first letters of words to try to disguise entries
                                                                         indexArray: MatchData.shared.colorIndices,
                                                                         submittedColors: MatchData.shared.submittedColorNames)
        
        
        
        
        MatchData.shared.submissionsByPlayer[userColorName.localizedCapitalized] = "Player \(MatchData.shared.currentPlayer)"
        
        // playersByRound[what turn are we on?][what player is this? (considering arrays start at 0)][get "Created" key] = set to submitted color name
        MatchData.shared.playersByRound[self.turnData.turnArray[0]][MatchData.shared.currentPlayer-1]["Created"] = userColorName.localizedCapitalized
        
        // clear the textfield
        self.userColorName = ""
        
        
        print("turnArray A: \(self.turnData.turnArray)")
        
        
        // advance the game
        self.turnData.turnArray = GameBrain().advanceGame(turnArray: self.turnData.turnArray,
                                                        indexArray: MatchData.shared.colorIndices,
                                                        playerCount: self.playerCount)
        
        print("turnArray B: \(self.turnData.turnArray)")
        
        // update GameData's copy of the turn array, which will be sent online
        MatchData.shared.turnArray = self.turnData.turnArray
        
        
        
        // toggle the "pass to next player" screen if we need to
        if GameBrain().isPlayerEnd(turnArray: self.turnData.turnArray) {
            
            if MatchData.shared.currentPlayer < self.playerCount {
                MatchData.shared.currentPlayer += 1
            } else {
                MatchData.shared.currentPlayer = 1
            }
            
            self.passToNextPlayer.toggle()
            
            
        }
        
        
    }
    */
    
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
                        .foregroundColor(Color.primaryTeal)
                    
                    
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
    
    public func mildHaptics() {
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
    
    public func mildHaptics2() {
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



#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 
 
 ContentView(numberOfPlayers: 2, onlineGame: false, indices: defaultIndicesArray) // default parameters
 }
 }
 */



