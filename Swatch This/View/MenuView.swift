//
//  MenuView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/9/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import GameKit
import CoreHaptics


struct MenuView: View {
   
    
    let localPlayer = GKLocalPlayer.local
    
    let palette = Palette()
    
    @State private var engine: CHHapticEngine?
    
    
    
    @State private var localFirst = false
    @State private var localSecond = false
    @State private var stackOffset = 0
    @State private var local1Offset = 1
    @State private var local2Offset = 2
    @State private var passAndPlay = false
    
    @State private var numberOfPlayers = 2
    
    
    @State var showingGameLocal = false
    @State var showingGameOnline = false
    @State var showingAbout = false
    @State var showingColors = false
    @State var showingHowTo = false
    @State var showingSettings = false
    
    @State private var showSignInView: Bool = false
    
    
    var gameData: GameData
    @EnvironmentObject var viewRouter: ViewRouter
    
    @EnvironmentObject var storeManager : StoreManager
    
    @EnvironmentObject var gameCenter : GameKitHelper
    @State private var isShowingGameCenter = false { didSet {
        PopupControllerMessage
            .GameCenter
        .postNotification() }}
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    @State var rotation1: Double = 0.0
    @State var rotation2: Double = 0.0
    
    @State private var paintOffsetX: CGFloat = 0
    
    
    
    var body: some View {
        
        ZStack {
            
            Color.primaryTealColor
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: {
                    prepareHaptics()
                })
                .onDisappear(perform: {
                    GKAccessPoint.shared.isActive = false
                })
            
            
            GeometryReader(content: geometricView(with:))
            
            
        }
        
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        let swatchHeight: CGFloat = min(geoWidth * 0.55, 280)
        
        
        var tileWidth = swatchHeight * 1.25
        
        if (tileWidth < 330) {
            tileWidth = geoWidth * 0.9
        }
        
        var tileHeight1 = min(swatchHeight * 1.6, 400)
        
        if (geoHeight / geoWidth > 2) {   // a very thin and tall screen, so allow the tileHeight1 to be large
            
            tileHeight1 = tileWidth * (geoHeight / geoWidth) * 0.5
        }
        
        
        
        var textWidth = swatchHeight
        
        if (textWidth < 250) {
            textWidth = tileWidth * 0.9
        }
        
        
        let tileHeight2 = min(swatchHeight * 1.6, 400)
        
        
        
        // Enable the Game Center access point, only when displaying the main menu
        if geoHeight < 650 {
            GKAccessPoint.shared.location = .bottomTrailing
        } else {
            GKAccessPoint.shared.location = .topTrailing
            
        }
        GKAccessPoint.shared.showHighlights = false
        
        if stackOffset == 0 {
            GKAccessPoint.shared.isActive = true
        } else {
            GKAccessPoint.shared.isActive = false
        }
        
        
        var localOffsetMultiplier: CGFloat = 1
        // push the decorative local swatches up more if we're on a device with a notch -- it looks better
        if geoHeight < 650 || (self.horizontalSizeClass == .regular && verticalSizeClass == .regular) {
        } else {
            localOffsetMultiplier = 1.5
        }
        
        
        return Group {
            
            
            VStack {
                
                
                Spacer()
                
                ZStack {
                    
                    menuSwatchStack(swatchHeight: swatchHeight)
                        .offset(x: geometry.size.width*CGFloat(self.stackOffset))
                    // .animation(Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: 0.5))
                    //  .animation(Animation.easeOut)
                        .animation(.spring())
                    
                    
                    
                    ZStack {
                        
                        if (geoHeight / geoWidth > 2) {
                            
                            SwatchStackView(swatchColor: Color.blushColor,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: 0, y: tileHeight1 * -0.1 * geoHeight/geoWidth - 30)
                            .rotationEffect(.degrees(-2))
                            
                            
                            SwatchStackView(swatchColor: Color.tangerineColor,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: 0, y: tileHeight1 * -0.1 * geoHeight/geoWidth)
                            .rotationEffect(.degrees(2))
                            
                        } else {
                            SwatchStackView(swatchColor: Color.blushColor,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: -20, y: -55 * localOffsetMultiplier)
                            .rotationEffect(.degrees(-11))
                            
                            SwatchStackView(swatchColor: Color.tangerineColor,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: 20, y: -43 * localOffsetMultiplier)
                            .rotationEffect(.degrees(14))
                            
                        }
                        
                        
                        
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.white)
                                .frame(width: tileWidth, height: tileHeight1, alignment: .center)
                                .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.25),
                                        radius: 5,
                                        y: 3)
                            
                            
                            ScrollView(.vertical) {
                                VStack {
                                    
                                    
                                    Spacer()
                                    
                                    
                                    Button(action: {
                                        
                                        self.mildHaptics()
                                        
                                        self.stackOffset = -2
                                        self.local1Offset = -1
                                        self.local2Offset = 0
                                        self.passAndPlay = true
                                        
                                    }) {
                                        Text("Pass & Play")
                                            .font(.title2)
                                            .bold()
                                    }
                                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                                    // .padding()
                                    
                                    //  Text("Players take turns by entering color names and then passing this device to the next player.")
                                    
                                    Text("Players enter \(colorLocalized) names and then pass this device to the next player")
                                        .font(.body)
                                    //  .frame(width: textWidth, alignment: .center)
                                    //  .frame(minHeight: 60)
                                    
                                        .padding()
                                    
                                    /*
                                     if geoHeight > 650 {
                                     Spacer()
                                     }
                                     */
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        self.mildHaptics()
                                        
                                        GKAccessPoint.shared.isActive = false
                                        
                                        self.viewRouter.currentPage = "tabletop"
                                        
                                        
                                    }) {
                                        Text("Pen & Paper")
                                            .font(.title2)
                                            .bold()
                                    }
                                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                                    //  .padding()
                                    
                                    Text("Players write their \(colorLocalized) names on paper and submit them to a round leader")
                                        .font(.body)
                                    //   .frame(minWidth: 10, idealWidth: textWidth, maxWidth: textWidth, minHeight: 60, idealHeight: 80, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    //  .frame(width: textWidth, alignment: .center)
                                    //  .frame(minHeight: 75)
                                        .padding()
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                    
                                    
                                    Button(action: {
                                        
                                        self.mildHaptics()
                                        
                                        self.stackOffset = 0
                                        self.local1Offset = 1
                                        self.local2Offset = 2
                                        self.passAndPlay = false
                                        
                                    }) {
                                        
                                        
                                        if  geoHeight > 700 {
                                            Text("Cancel")
                                                .font(.body)
                                                .bold()
                                                .padding()
                                        } else {
                                            Text("Cancel")
                                                .font(.body)
                                                .bold()
                                        }
                                        
                                        
                                        //   .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                        
                                    }
                                    
                                }
                            }
                            .frame(width: tileWidth, height: tileHeight1, alignment: .center)
                            //   .clipped()
                            
                        }
                        
                    }
                    .offset(x: geometry.size.width*CGFloat(self.local1Offset))
                    //     .animation(Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: 0.5))
                    // .animation(Animation.easeOut)
                    .animation(.spring())
                    
                    
                    ZStack {
                        
                        
                        if (self.numberOfPlayers > 7) {
                            
                            SwatchStackView(swatchColor: Color(hex: gameBrain.getColorHex(turn: 0, indexArray: [Int.random(in: 0...palette.masterPalette.count-1)])),
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: CGFloat.random(in: -25 ..< 25), y: CGFloat.random(in: -60 ..< 35))
                            .rotationEffect(.degrees(Double.random(in: -18 ..< 18)))
                        }
                        
                        if (self.numberOfPlayers > 6) {
                            
                            SwatchStackView(swatchColor: Color(hex: gameBrain.getColorHex(turn: 0, indexArray: [Int.random(in: 0...palette.masterPalette.count-1)])),
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: CGFloat.random(in: -25 ..< 25), y: CGFloat.random(in: -60 ..< 35))
                            .rotationEffect(.degrees(Double.random(in: -18 ..< 18)))
                        }
                        
                        if (self.numberOfPlayers > 5) {
                            
                            SwatchStackView(swatchColor: Color(hex: gameBrain.getColorHex(turn: 0, indexArray: [Int.random(in: 0...palette.masterPalette.count-1)])),
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: CGFloat.random(in: -25 ..< 25), y: CGFloat.random(in: -60 ..< 35))
                            .rotationEffect(.degrees(Double.random(in: -18 ..< 18)))
                        }
                        
                        if (self.numberOfPlayers > 4) {
                            
                            SwatchStackView(swatchColor: Color(hex: gameBrain.getColorHex(turn: 0, indexArray: [Int.random(in: 0...palette.masterPalette.count-1)])),
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: CGFloat.random(in: -25 ..< 25), y: CGFloat.random(in: -60 ..< 35))
                            .rotationEffect(.degrees(Double.random(in: -18 ..< 18)))
                        }
                        
                        if (self.numberOfPlayers > 3) {
                            
                            SwatchStackView(swatchColor: Color(hex: gameBrain.getColorHex(turn: 0, indexArray: [Int.random(in: 0...palette.masterPalette.count-1)])),
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: CGFloat.random(in: -25 ..< 25), y: CGFloat.random(in: -60 ..< 35))
                            .rotationEffect(.degrees(Double.random(in: -18 ..< 18)))
                        }
                        
                        if (self.numberOfPlayers > 2) {
                            
                            SwatchStackView(swatchColor: Color(hex: gameBrain.getColorHex(turn: 0, indexArray: [Int.random(in: 0...palette.masterPalette.count-1)])),
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            .offset(x: CGFloat.random(in: -25 ..< 25), y: CGFloat.random(in: -60 ..< 35))
                            .rotationEffect(.degrees(Double.random(in: -18 ..< 18)))
                        }
                        
                        
                        SwatchStackView(swatchColor: Color.blushColor,
                                        swatchHeight: swatchHeight,
                                        text: "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 10,
                                        inGame: false,
                                        turnNumber: 0)
                        .offset(x: CGFloat.random(in: 15 ..< 19), y: CGFloat.random(in: -40 ..<  -30))
                        .rotationEffect(.degrees(Double.random(in: 10 ..< 14)))
                        
                        
                        SwatchStackView(swatchColor: Color.darkGreenColor,
                                        swatchHeight: swatchHeight,
                                        text: "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 10,
                                        inGame: false,
                                        turnNumber: 0)
                        .offset(x: CGFloat.random(in: -16 ..< -12), y: CGFloat.random(in: -50 ..< -40))
                        .rotationEffect(.degrees(Double.random(in: -15 ..< -11)))
                        
                        
                        
                        
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: swatchHeight+swatchHeight*0.2, height: tileHeight2, alignment: .center)
                            .foregroundColor(.white)
                            .shadow(color: Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.25),
                                    radius: 5,
                                    y: 3)
                        
                        VStack(spacing: 15) {
                            
                            Text("How many players?")
                                .font(.system(size: 18))
                            
                            Text("\(self.numberOfPlayers)")
                                .foregroundColor(Color.darkGreenColor)
                                .font(.system(size: 70))
                                .fontWeight(.bold)
                                .padding()
                            
                            
                            HStack {
                                Spacer()
                                
                                if (isiOSAppOnMac == true) {
                                    
                                    Button(action: {
                                        
                                        if (self.numberOfPlayers > 2) {
                                            
                                            self.numberOfPlayers -= 1
                                        }
                                        
                                    }) {
                                        
                                        Text("–")
                                            .font(.system(size: 40))
                                            .bold()
                                            .padding()
                                    }
                                    .disabled(self.numberOfPlayers <= 2)
                                    
                                    Button(action: {
                                        
                                        if (self.numberOfPlayers < 8) {
                                            
                                            self.numberOfPlayers += 1
                                        }
                                        
                                    }) {
                                        Text("+")
                                            .font(.system(size: 40))
                                            .bold()
                                            .padding()
                                    }
                                    .disabled(self.numberOfPlayers >= 8)
                                    
                                } else {
                                    
                                    Stepper("", value: self.$numberOfPlayers, in: 2...8, onEditingChanged: {_ in
                                        self.strongHaptics()
                                    })
                                    .frame(width: 100, height: 50)
                                }
                                
                                
                                Spacer()
                            }
                            
                            
                            Button(action: {
                                //   self.showingGameLocal.toggle()
                                
                                self.mildHaptics()
                                
                                
                                self.viewRouter.playerCount = self.numberOfPlayers
                                //  self.viewRouter.colorIndices = self.indices
                                GKAccessPoint.shared.isActive = false
                                
                                if self.passAndPlay == true {
                                    self.viewRouter.currentPage = "game"
                                    
                                } else {
                                    self.viewRouter.currentPage = "tabletop"
                                    
                                }
                                
                                
                            }) {
                                Text("Play")
                                    .font(.system(size: 23))
                                    .bold()
                            }
                            
                            
                            Button(action: {
                                
                                self.mildHaptics2()
                                
                                self.stackOffset = -1
                                self.local1Offset = 0
                                self.local2Offset = 1
                                
                            }) {
                                Text("Cancel")
                                    .font(.system(size: 20))
                                
                            }
                        }
                        
                    }.offset(x: geometry.size.width*CGFloat(self.local2Offset))
                    //  .animation(Animation.timingCurve(0.02, 0.95, 0.4, 0.95, duration: 0.5))
                    //  .animation(Animation.easeOut)
                        .animation(.spring())
                    
                    
                }
                .offset(y: 20)
                
                Spacer()
                
                ZStack(alignment: .center) {
                    
                    
                    Image("Paint Stripe")
                    //  .resizable()
                    //  .scaledToFit()
                        .frame(width: geometry.size.width, height: 250, alignment: .center)
                        .offset(y: 3)
                    
                    
                    
                    VStack(spacing: 20) {
                        
                        Button(action: {
                            
                            self.mildHaptics()
                            
                            /*
                             if self.gameCenter.enabled {
                             
                             GKAccessPoint.shared.isActive = false
                             self.viewRouter.onlineGame = true
                             
                             
                             self.isShowingGameCenter.toggle()
                             self.viewRouter.playerCount = self.numberOfPlayers
                             
                             
                             self.viewRouter.currentPage = "loading"
                             
                             
                             } else {
                             
                             /*
                              let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                              self.showSignInView = authUser == nil
                              AuthenticationView(showSignInView: $showSignInView)
                              */
                             
                             NotificationCenter.default.post(name: .gameCenterAlert, object: nil)
                             
                             }
                             */
                            
                            self.viewRouter.onlineGame = true
                            self.viewRouter.currentPage = "loading"
                            
                            
                        }) {
                            HStack {
                                Image(systemName: "paintbrush.fill")
                                Text("Play Online")
                            }
                            .font(.system(size: 23))
                            .bold()
                        }.disabled(self.localFirst)
                        
                        
                        //   } else {
                        
                        //        Text("Play Online")
                        //           .foregroundColor(.gray)
                        //    }
                        
                        
                        
                        Button(action: {
                            
                            self.mildHaptics()
                            
                            self.viewRouter.onlineGame = false
                            GKAccessPoint.shared.isActive = false
                            
                            self.stackOffset = -1
                            self.local1Offset = 0
                            self.local2Offset = 1
                            
                        }) {
                            HStack {
                                Image(systemName: "paintbrush.pointed.fill")
                                Text("Play Locally")
                            }
                            .font(.system(size: 23))
                            .bold()
                        }.disabled(self.localFirst)
                        
                        
                        
                        Button(action: {
                            
                         //   uploadCodesToFirebase() // for adding colors codes to the MatchCodes database

                            self.mildHaptics()
                            GKAccessPoint.shared.isActive = false
                            
                            self.showingColors.toggle()
                        }) {
                            HStack {
                                Image(systemName: "swatchpalette")
                                Text("\(colorLocalizedCap)s") // Colors
                            }
                            .font(.system(size: 21))
                            
                        }
                        .sheet(isPresented: self.$showingColors) {
                            
                            ColorsView(isPresented: self.$showingColors,
                                       hexes: self.setUpPalettePackColors().hex,
                                       rotations: self.setUpPalettePackColors().rotation,
                                       baseGameHexes: gameBrain.getBaseGameColors().shuffled())
                        }
                        
                        
                        
                        
                        
                        Button(action: {
                            
                            self.mildHaptics()
                            GKAccessPoint.shared.isActive = false
                            
                            self.showingHowTo.toggle()
                        }) {
                            HStack {
                                Image(systemName: "book.pages")
                                Text("How to Play")
                            }
                            .font(.system(size: 21))
                            
                        }
                        .sheet(isPresented: self.$showingHowTo) {
                            HowToView(isPresented: self.$showingHowTo)
                        }
                        
                        
                    }.onAppear() {
                        
                        GameKitHelper.sharedInstance
                            .authenticateLocalPlayer()
                        
                    }
                    
                    
                }
                .accentColor(Color.tangerineTextColor)
                
                
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        
                        self.mildHaptics()
                        GKAccessPoint.shared.isActive = false
                        
                        self.showingAbout.toggle()
                    }) {
                        HStack {
                            Image(systemName: "star.circle")
                            Text("About")
                        }
                        
                    }
                    .padding()
                    .sheet(isPresented: self.$showingAbout) {
                        AboutView(isPresented: self.$showingAbout)
                    }
                    
                    
                    
                    Spacer()
                    
                    
                    
                    Button(action: {
                        
                        self.mildHaptics()
                        GKAccessPoint.shared.isActive = false
                        
                        self.showingSettings.toggle()
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        
                    }
                    .padding()
                    .sheet(isPresented: self.$showingSettings) {
                        //  let displayName = try await UserManager.shared.getUserDisplayName()
                        
                        SettingsView(showSignInView: $showSignInView)
                    }
                    
                    
                }
                .accentColor(Color(.white))
                
                
            }
            
        }
        
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
    
    
    
    func setUpPalettePackColors() -> (hex: [UInt32], rotation: [Double]) {
        
        let paletteColors = gameBrain.getIAPColors().shuffled()
        
        var rotationArray: [Double] = [Double.random(in: -5 ..< 5)]
        
        
        for _ in 1...paletteColors.count-1 {
            
            rotationArray.append(Double.random(in: -5 ..< 5))
        }
        
        
        return (paletteColors, rotationArray)
        
    }
    
    
    
    
}


extension MenuView {
    
    private func menuSwatchStack(swatchHeight: CGFloat) -> some View {
        
        ZStack {
            
            SwatchStackView(swatchColor: Color.blushColor,
                            swatchHeight: swatchHeight,
                            text: "",
                            textField: nil,
                            subtext: "",
                            fontSize: 10,
                            inGame: false,
                            turnNumber: 0)
            .offset(x: 13, y: -29)
            .rotationEffect(.degrees(self.rotation1))
            .onAppear {
                //  let baseAnimation = Animation.easeInOut(duration: 1)
                let baseAnimation = Animation.spring()
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    return withAnimation(baseAnimation) {
                        self.rotation1 = 14.0
                    }
                }
            }
            
            SwatchStackView(swatchColor: Color.darkGreenColor,
                            swatchHeight: swatchHeight,
                            text: "",
                            textField: nil,
                            subtext: "",
                            fontSize: 10,
                            inGame: false,
                            turnNumber: 0)
            .offset(x: -10, y: -23)
            .rotationEffect(.degrees(self.rotation2))
            .onAppear {
                //   let baseAnimation = Animation.easeInOut(duration: 1)
                let baseAnimation = Animation.spring()
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    return withAnimation(baseAnimation) {
                        self.rotation2 = -9.0
                    }
                }
            }
            SwatchStackView(swatchColor: Color.tangerineColor,
                            swatchHeight: swatchHeight,
                            text: "Swatch This",
                            textField: nil,
                            subtext: "a game about \(colorLocalized)",
                            fontSize: 10,
                            inGame: false,
                            turnNumber: 0)
            
            
        }
        
        
    }
}



extension Notification.Name {
    static let gameCenterAlert = Notification.Name(rawValue: "gameCenterAlert")
}


/*
 struct MenuView_Previews: PreviewProvider {
 static var previews: some View {
 MenuView()
 
 }
 }
 
 */

