//
//  ColorsView.swift
//  Swatch This
//
//  Created by Russ Hooper on 2/16/21.
//  Copyright © 2021 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics
import GameKit
import StoreKit

struct ColorsView: View {
    
    @Binding var isPresented: Bool
    let hexes: [UInt32]
    let rotations: [Double]
    let baseGameHexes: [UInt32]
    
    @State private var engine: CHHapticEngine?
    
    
    let swatchColor1: UInt32 = 0x130f50
    let swatchColor2: UInt32 = 0xfcba03
    let swatchColor3: UInt32 = 0x487eb0
    let swatchColor4: UInt32 = 0xe84118
    let swatchColor5: UInt32 = 0xB21B2F
    let swatchColor6: UInt32 = 0x78888E
    let swatchColor7: UInt32 = 0xA4A085
    let moonriseColor1: UInt32 = 0xFCD16C
    let moonriseColor2: UInt32 = 0x88D4E2
    let moonriseColor3: UInt32 = 0x759F89
    let moonriseColor4: UInt32 = 0xE0A295
    let denimColor: UInt32 = 0x4F98C3
    let tangerineColorText: UInt32 = 0xFA9343
    let babySealBlack: UInt32 = 0x474B51
    let grayFlannel: UInt32 = 0x585861
    let californiaWineColor: UInt32 = 0xC94B66
    let lightPinkColor: UInt32 = 0xE0A295
    let blushColor: UInt32 = 0xf95352
    
    
    @State var userColorName: String = ""
    
    
    @State var scrollOffset: CGFloat = 0.0
    
    @State var showConfetti = false
    @State var showSpinner = false
    @State var forceViewUpdate = false
    @State var enableBaseGame = UserDefaults.standard.bool(forKey: "swatchthis.basegame.enabled")
    @State var enablePalettePack = UserDefaults.standard.bool(forKey: "swatchthis.palettepack1.enabled")
    
    @State var confettiAlpha = 1.0
    
    let paymentQueueUpdatePub = NotificationCenter.default
        .publisher(for: NSNotification.Name("paymentQueueUpdate"))
    
    let paymentQueueErrorPub = NotificationCenter.default
        .publisher(for: NSNotification.Name("paymentQueueError"))
    
    
    @Environment(\.sizeCategory) var sizeCategory
    
    
    //  @StateObject var storeManager = StoreManager()
    
    // @EnvironmentObject var storeManager : StoreManager
    
    
    var gridItemLayout = [GridItem(.fixed(10)),
                          GridItem(.fixed(10)),
                          GridItem(.fixed(10)),
                          GridItem(.fixed(10))]
    
    
    var body: some View {
        
        
        GeometryReader(content: geometricView(with:))
            .onAppear(perform: {
                GKAccessPoint.shared.isActive = false
                prepareHaptics()
            })
            .onReceive(paymentQueueUpdatePub) { output in
                
                self.showSpinner = false
                self.showConfetti = UserDefaults.standard.bool(forKey: "swatchthis.IAP.palettepack1")   // show confetti upon unlock of Palette Pack
                
                if self.showConfetti == true {
                    UserDefaults.standard.setValue(true, forKey: "swatchthis.basegame.enabled")    // we want the players to use all the colors, so set Base Game to enabled once the Palette Pack is unlocked
                    self.enableBaseGame = true
                    UserDefaults.standard.setValue(true, forKey: "swatchthis.palettepack1.enabled")    // we want the players to use all the colors, so set Palette Pack to enabled once the Palette Pack is unlocked
                    self.enablePalettePack = true
                }
                self.forceViewUpdate.toggle()
                
            }
            .onReceive(paymentQueueErrorPub) { output in
                
                self.showSpinner = false
                self.forceViewUpdate.toggle()
                
            }
            .onAppear(perform: {
                GKAccessPoint.shared.isActive = false
            })
            .onDisappear(perform: {
                GKAccessPoint.shared.isActive = true
            })
        
        
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        
        
        
        var price = "Buy"
        var cannotRetrieveProducts = true
        
        if (StoreManager.sharedInstance.myProducts.count > 0) {
            price = StoreManager.sharedInstance.myProducts[0].localizedPrice
            cannotRetrieveProducts = false
        }
        
        
        // I tried putting this in GameBrain but I can't figure out how to pass in the environment object size class
        var textMinHeight: CGFloat = 10.0  // a small number
        var textMinHeightMultiplier: CGFloat = 1.0
        
        if self.sizeCategory == .extraLarge ||
            self.sizeCategory == .extraExtraLarge ||
            self.sizeCategory == .extraExtraExtraLarge {
            
            textMinHeight = 100.0
            textMinHeightMultiplier = 1.6
            
            
        } else if self.sizeCategory == .accessibilityMedium ||
                    self.sizeCategory == .accessibilityLarge ||
                    self.sizeCategory == .accessibilityExtraLarge {
            
            textMinHeight = 120.0
            textMinHeightMultiplier = 3.0
            
        } else if self.sizeCategory == .accessibilityExtraExtraLarge ||
                    self.sizeCategory == .accessibilityExtraExtraExtraLarge {
            
            textMinHeight = 150.0
            textMinHeightMultiplier = 4.0
        }
        
        
        
        return Group {
            
            
            ZStack {
                
                Color(darkTealColor)
                    .edgesIgnoringSafeArea(.all)
                
                
                
                VStack(alignment: .center) {
                    
                    // scrolling swatches
                    LazyHStack(spacing: -10) {
                        
                        ForEach(hexes.indices, id: \.self) { i in
                            
                            SwatchStackView(color: hexes[i],
                                            swatchHeight: 120,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                                .rotationEffect(.degrees(self.rotations[i]))
                            
                            
                        }
                        .offset(x: self.scrollOffset)
                    }
                    .frame(width: geoWidth, height: 250, alignment: .leading)
                    .onAppear {
                        let baseAnimation = Animation.linear(duration: Double(self.hexes.count)*3.0)
                            .repeatForever(autoreverses: true)
                        
                        return withAnimation(baseAnimation) {
                            self.scrollOffset = CGFloat(self.hexes.count) * -80.0
                            
                        }
                    }
                    
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("The Palette")
                                //  .font(.title)
                                .font(.system(size: 26))
                                // .fontWeight(.medium)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                            
                            Text("Pack")
                                // .font(.title)
                                .font(.system(size: 26))
                                
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                                
                                //   .frame(width: geoWidth*0.75, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 0))
                                .opacity(0.7)
                        }
                        
                        
                        Spacer()
                        
                        if showSpinner == true {
                            
                            //  while StoreKit is thinking, we'll hide the buttons and show a spinner
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60, alignment: .center)
                                
                                ActivityIndicator()
                                
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 40))
                            
                            
                        } else if cannotRetrieveProducts == true {
                            
                            Text("Error: cannot connect\nto App Store.")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                            
                            
                        } else {
                            
                            if UserDefaults.standard.bool(forKey: "swatchthis.IAP.palettepack1") {
                                
                                VStack {
                                    
                                    
                                    Image(systemName: "checkmark.square.fill")
                                        .font(Font.system(.largeTitle))
                                        .foregroundColor(.white)
                                    
                                    Text("Unlocked!")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                                
                                
                            } else {
                                
                                VStack(alignment: .center) {
                                    
                                    Button(action: {
                                        
                                        StoreManager.sharedInstance.purchaseProduct(product: StoreManager.sharedInstance.myProducts[0])
                                        self.correctGuessHaptics()
                                        
                                        self.showSpinner = true
                                        
                                        
                                    }) {
                                        // Text("$1.99")
                                        
                                        Text("\(price)")
                                            .fontWeight(.bold)
                                            .padding()
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(lineWidth: 1)
                                            )
                                        
                                    }
                                    
                                    
                                    Button(action: {
                                        
                                        
                                        StoreManager.sharedInstance.restoreProducts()
                                        self.correctGuessHaptics()
                                        self.showSpinner = true
                                        
                                        
                                        
                                    }) {
                                        
                                        Text("Restore Purchase")
                                        
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 20))
                                
                                
                                
                            }
                        }
                    }
                    
                    
                    // bottom, white part of view
                    ZStack(alignment: .top) {
                        
                        Color(.white)
                            .edgesIgnoringSafeArea(.all)
                        
                        Image("Paint Stripe")
                            //  .resizable()
                            //  .scaledToFit()
                            .frame(width: geometry.size.width, height: 230, alignment: .center)
                            .rotationEffect(.degrees(180))
                            .offset(y: -30)
                        
                        
                        
                        ScrollView(.vertical) {
                            VStack (alignment: .leading) {
                                
                                Text("Unlock tons of new \(colorLocalized)s for use in Swatch This matches.")
                                    .frame(minHeight: textMinHeight)
                                    .foregroundColor(Color(darkTealColor))
                                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                                
                                Spacer()
                                
                                VStack (alignment: .leading) {
                                    Text("Base game:")
                                        .foregroundColor(Color(darkTealColor))
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                    
                                    HStack {
                                        
                                        if self.enablePalettePack == true {
                                            
                                            Button(action: {
                                                
                                                self.enableBaseGame.toggle()
                                                
                                                UserDefaults.standard.setValue(self.enableBaseGame, forKey: "swatchthis.basegame.enabled")
                                                
                                            }) {
                                                
                                                if self.enableBaseGame == true {
                                                    
                                                    Image(systemName: "checkmark.square")
                                                        .font(Font.system(.largeTitle))
                                                    //  .foregroundColor(.white)
                                                    
                                                } else {
                                                    
                                                    Image(systemName: "square")
                                                        .font(Font.system(.largeTitle))
                                                    //  .foregroundColor(.white)
                                                }
                                            }
                                        } else {
                                            
                                            Image(systemName: "checkmark.square")
                                                .font(Font.system(.largeTitle))
                                                .foregroundColor(Color(darkTealColor))
                                        }
                                        
                                        
                                        ScrollView(.horizontal) {
                                            LazyHGrid(rows: self.gridItemLayout, spacing: 2) {
                                                ForEach(self.baseGameHexes.indices, id: \.self) { i in
                                                    
                                                    Rectangle()
                                                        .foregroundColor(Color(self.baseGameHexes[i]))
                                                        .frame(width: 10, height: 10)
                                                    
                                                }
                                            }
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        
                                        
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                    
                                }
                                
                                Spacer()
                                //   .frame(height: 30)
                                
                                VStack (alignment: .leading) {
                                    Text("The Palette Pack:")
                                        .foregroundColor(Color(darkTealColor))
                                        .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                                    
                                    HStack {
                                        
                                        
                                        if UserDefaults.standard.bool(forKey: "swatchthis.IAP.palettepack1") == true {
                                            
                                            Button(action: {
                                                
                                                self.enablePalettePack.toggle()
                                                
                                                UserDefaults.standard.setValue(self.enablePalettePack, forKey: "swatchthis.palettepack1.enabled")
                                                
                                                
                                            }) {
                                                
                                                
                                                if self.enablePalettePack == true {
                                                    
                                                    Image(systemName: "checkmark.square")
                                                        .font(Font.system(.largeTitle))
                                                    //    .padding()
                                                    
                                                } else {
                                                    
                                                    Image(systemName: "square")
                                                        .font(Font.system(.largeTitle))
                                                    //    .padding()
                                                }
                                            }
                                        } else {
                                            
                                            
                                            Image(systemName: "square")
                                                .font(Font.system(.largeTitle))
                                                .foregroundColor(Color(darkTealColor))
                                            //  .padding()
                                            
                                        }
                                        
                                        
                                        ScrollView(.horizontal) {
                                            LazyHGrid(rows: self.gridItemLayout, spacing: 2) {
                                                ForEach(self.hexes.indices, id: \.self) { i in
                                                    
                                                    Rectangle()
                                                        .foregroundColor(Color(self.hexes[i]))
                                                        .frame(width: 10, height: 10)
                                                }
                                            }
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                        
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                    
                                }
                                Spacer()
                                
                                Text("\(gameBrain.getAvailablePalette(excludeRecentColors: false).count) \(colorLocalized)s active.")
                                    .foregroundColor(Color(darkTealColor))
                                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                                
                                Text("When playing an online match, all players will have access to the same \(colorLocalized)s as the person who takes the first turn.")
                                    .frame(minHeight: textMinHeight * textMinHeightMultiplier)
                                    .foregroundColor(Color(darkTealColor))
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10))
                                
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // make screen-wide
                            
                        }
                    }
                    
                    
                }
                
                
                if self.showConfetti == true {
                    
                    // problem: confetti view is on top of Z stack, so we can't use the palette horizontal scroll views.
                    // solution: remove confetti view after it's done.
                    // however: let's make the whole thing 4 seconds. So fade it out after 3, then remove it after 4
                    
                    SASuperConfettiSwiftUIView(startSuperConfettiBurst: true,
                                               confettiFrame: CGRect(x: 0, y: 0, width: geoWidth, height: geoHeight))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(self.confettiAlpha)
                        
                        .onAppear(perform: {
                            
                            withAnimation(Animation.easeInOut(duration: 1.0).delay(3.0)) {
                                self.confettiAlpha = 0.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                self.showConfetti = false
                            }
                        })
                    
                    
                }
            }
            .frame(width: geoWidth,
                   height: geoHeight,
                   alignment: .center) // this fixes the confusing new iOS 14 SwiftUI alignment behavious. Alignment here should function as expected.
            
            
            
        }
        .accentColor(Color(tangerineColorText))
        
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
}

