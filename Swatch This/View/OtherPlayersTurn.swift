//
//  OtherPlayersTurn.swift
//  Swatch This
//
//  Created by Russ Hooper on 8/9/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics


struct OtherPlayersTurn: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var engine: CHHapticEngine?
    
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    
    let colorIndices: [Int]
    
    @State var animateIn0 = false
    @State var animateIn1 = false
    @State var animateIn2 = false
    @State var animateIn3 = false

    @State private var paintOffsetX: CGFloat = 0

    private let dealDuration: TimeInterval = 0.75
    private let dealDelay0: TimeInterval = 0
    private let dealDelay1: TimeInterval = 0.1
    private let dealDelay2: TimeInterval = 0.2
    private let dealDelay3: TimeInterval = 0.3
    
    var rotations: [Double]


    
    
    var body: some View {
        
        GeometryReader(content: geometricView(with:))
        
    }
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height

        let swatchHeight: CGFloat = min(geoWidth/3.8, 120)
        
        
        var tileWidth = swatchHeight * 1.25
        
        if (tileWidth < 330) {
            tileWidth = geoWidth * 0.9
        }
        
        
        
        var textWidth = swatchHeight
        
        if (textWidth < 250) {
            textWidth = tileWidth * 0.9
        }
        
        
                
        let titleText = "Waiting on \(GameKitHelper.sharedInstance.getCurrentPlayer())"
    
        
        var largeText = true
        
        if self.sizeCategory == .extraSmall ||
            self.sizeCategory == .small ||
            self.sizeCategory == .medium ||
            self.sizeCategory == .large {
            
            largeText = false
            // we don't need to accommodate the larger system text sizes
            
        } else if (self.sizeCategory == .extraLarge || self.sizeCategory == .extraExtraLarge) &&
                    self.horizontalSizeClass == .regular &&
                    self.verticalSizeClass == .regular {
            // be less restrictive on large devices
            
            largeText = false

        }
        
        
        
        
        return Group {
            
            ZStack {
                
                Color.primaryTealColor
                    .edgesIgnoringSafeArea(.all)
                    .onAppear(perform: prepareHaptics)
                
                
                
                /*
                 Rectangle()
                 .frame(width: 2000, height: 350, alignment: .center)
                 .foregroundColor(.white)
                 .rotationEffect(.degrees(20))
                 */
                
                VStack {
                    
                    
                    Spacer()
                    
                    
                    if self.colorIndices.reduce(0, +) > 0 { // check if we have a real color indices array by comparing its sum to 0
                        
                        HStack {
                            
                            
                            
                            SwatchView(colorIndices: self.colorIndices,
                                       colorAtIndex: 0,
                                       swatchHeight: swatchHeight,
                                       colorName: "",
                                       company: "",
                                       colorURL: "",
                                       coverOpacity: 0.0,
                                       logoOpacity: 0.0,
                                       nameOpacity: 0.0,
                                       fontSize: 10,
                                       showTurns: false)
                                .rotationEffect(self.animateIn3 ? .degrees(self.rotations[3]) : .degrees(0))
                                .opacity(self.animateIn3 ? 1 : 0)
                                .offset(x: 0, y: self.animateIn3 ? 0 : -geoHeight/3)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration))    // controls deal animation
                                .onAppear { // triggers deal animation
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay3) {
                                        self.animateIn3 = true
                                    }
                                }
                                .padding()

                            
                            SwatchView(colorIndices: self.colorIndices,
                                       colorAtIndex: 1,
                                       swatchHeight: swatchHeight,
                                       colorName: "",
                                       company: "",
                                       colorURL: "",
                                       coverOpacity: 0.0,
                                       logoOpacity: 0.0,
                                       nameOpacity: 0.0,
                                       fontSize: 10,
                                       showTurns: false)
                                .rotationEffect(self.animateIn2 ? .degrees(self.rotations[2]) : .degrees(0))
                                .opacity(self.animateIn2 ? 1 : 0)
                                .offset(x: 0, y: self.animateIn2 ? 0 : -geoHeight/3)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration))    // controls deal animation
                                .onAppear { // triggers deal animation
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay2) {
                                        self.animateIn2 = true
                                    }
                                }
                                .padding()
                            
                            
                        }
                        .padding()
                        
                        HStack {
                            
                            SwatchView(colorIndices: self.colorIndices,
                                       colorAtIndex: 2,
                                       swatchHeight: swatchHeight,
                                       colorName: "",
                                       company: "",
                                       colorURL: "",
                                       coverOpacity: 0.0,
                                       logoOpacity: 0.0,
                                       nameOpacity: 0.0,
                                       fontSize: 10,
                                       showTurns: false)
                                .rotationEffect(self.animateIn1 ? .degrees(self.rotations[1]) : .degrees(0))
                                .opacity(self.animateIn1 ? 1 : 0)
                                .offset(x: 0, y: self.animateIn1 ? 0 : -geoHeight/3)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration))    // controls deal animation
                                .onAppear { // triggers deal animation
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay1) {
                                        self.animateIn1 = true
                                    }
                                }
                                .padding()
                            
                            
                            SwatchView(colorIndices: self.colorIndices,
                                       colorAtIndex: 3,
                                       swatchHeight: swatchHeight,
                                       colorName: "",
                                       company: "",
                                       colorURL: "",
                                       coverOpacity: 0.0,
                                       logoOpacity: 0.0,
                                       nameOpacity: 0.0,
                                       fontSize: 10,
                                       showTurns: false)
                                .rotationEffect(self.animateIn0 ? .degrees(self.rotations[0]) : .degrees(0))
                                .opacity(self.animateIn0 ? 1 : 0)
                                .offset(x: 0, y: self.animateIn0 ? 0 : -geoHeight/3)
                                .animation(.timingCurve(0.02, 0.95, 0.4, 0.95, duration: self.dealDuration))    // controls deal animation
                                .onAppear { // triggers deal animation
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay0) {
                                        self.animateIn0 = true
                                    }
                                }
                                .padding()
                            
                            
                            
                        }
                    } else {    // we don't have a real color indices array, so just show the "About" swatch stack
                        
                        
                        ZStack {
                            
                            SwatchStackView(swatchColor: Color.grayColor2,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                                .offset(x: -15, y: -6)
                                .rotationEffect(.degrees(-11))
                            
                            
                            SwatchStackView(swatchColor: Color.grayColor3,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                                .offset(x: 12, y: -21)
                                .rotationEffect(.degrees(+15))
                            
                            
                            SwatchStackView(swatchColor: Color.grayColor1,
                                            swatchHeight: swatchHeight,
                                            text: "",
                                            textField: nil,
                                            subtext: "",
                                            fontSize: 10,
                                            inGame: false,
                                            turnNumber: 0)
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    Spacer()
                    
                    
                    if largeText == true {
                        
                        textScrollView(geoWidth: geoWidth, titleText: titleText)
                            .padding(.top)
                        
                    } else {
                        
                        textStripeView(geoWidth: geoWidth, titleText: titleText)
                        
                        Spacer()

                    }
                    
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            .accentColor(Color.tangerineTextColor)
        }
        
    }
    
    
    func textScrollView(geoWidth: CGFloat, titleText: String) -> some View {
        
        
        
        
        return Group {
            
            
            ZStack(alignment: .top) {
                
                
                Color(.white)
                 //   .offset(y: 20)
                
                /*
                Image("Paint Stripe")
                    //  .resizable()
                    //  .scaledToFit()
                    .frame(width: geoWidth, height: 230, alignment: .center)
                    .rotationEffect(.degrees(180))
                    .edgesIgnoringSafeArea(.all)
                */
                
                
                
                ScrollView(.vertical) {
                    
                    VStack {
                        
                        Spacer()
                        
                        
                        Text(titleText)
                            .font(.title2)
                            .bold()
                            .multilineTextAlignment(.center)
                            //  .frame(width: geometry.size.width-20, alignment: .center)
                            .padding()
                        
                        
                 //       Spacer()
                        
                        if self.colorIndices.reduce(0, +) > 0 { // check if we have a real color indices array by comparing its sum to 0
                            Text("You'll be notified when it's your turn again!")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                //    .frame(width: geometry.size.width-20, alignment: .center)
                                .padding()
                            
                        } else {    // probably isn't yet the player's first turn
                            
                            Text("It's not your turn yet — you'll be notified when it is!")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                //   .frame(width: geometry.size.width-20, alignment: .center)
                                .padding()
                        }
                        
                 //       Spacer()
                        
                        Button(action: {
                            
                            self.mildHaptics2()
                            
                            self.viewRouter.currentPage = "menu"
                        }) {
                            Text("Return to Menu")
                                .font(.title2)
                                .bold()
                                .padding()
                            //                        .hoverEffect(.automatic)
                            
                        }
                        
                        Spacer()
                        
                        
                    }
                }
             //       .frame(width: geoWidth, height: 202, alignment: .center)
                
            }
            .edgesIgnoringSafeArea(.all)

        }
    }
    
    func textStripeView(geoWidth: CGFloat, titleText: String) -> some View {
        
        return Group {
            
            
            ZStack {
                
                            
                Image("Paint Stripe")
                    //  .resizable()
                    //  .scaledToFit()
                    .frame(width: geoWidth, height: 230, alignment: .center)
                    .rotationEffect(.degrees(180))
                    .edgesIgnoringSafeArea(.all)
                                
                
                
                VStack {
                    
                    Spacer()
                    
                    
                    Text(titleText)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        //  .frame(width: geometry.size.width-20, alignment: .center)
                        .padding()
                    
                    
                    Spacer()
                    
                    if self.colorIndices.reduce(0, +) > 0 { // check if we have a real color indices array by comparing its sum to 0
                        Text("You'll be notified when it's your turn again!")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            //    .frame(width: geometry.size.width-20, alignment: .center)
                            .padding()
                        
                    } else {    // probably isn't yet the player's first turn
                        
                        Text("It's not your turn yet — you'll be notified when it is!")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            //   .frame(width: geometry.size.width-20, alignment: .center)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                        self.mildHaptics2()
                        
                        self.viewRouter.currentPage = "menu"
                    }) {
                        Text("Return to Menu")
                            .font(.title2)
                            .bold()
                            .padding()
                        //                        .hoverEffect(.automatic)
                        
                    }
                    
                    Spacer()
                    
                    
                }
                .frame(width: geoWidth, height: 202, alignment: .center)
                
                
                /*
                Image("Paint Stripe Reveal")
                    .frame(width: geoWidth, height: 230, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: self.paintOffsetX)
                    .animation(.linear(duration: 0.5))
                    .onAppear {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.dealDelay3) {
                            self.paintOffsetX = 1700

                        }
                    }
                 */
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
}

