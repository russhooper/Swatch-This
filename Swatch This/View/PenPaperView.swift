//
//  PenPaperView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/19/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics

/*
struct PenPaperView: View {
    
    var gameData: GameData
    
    
    let fontSize: CGFloat = 22.0
    
    @State var showingColor = false
    @State var colorAtIndex: Int = 0
    @State var showingHowTo = false
    
    @State private var engine: CHHapticEngine?
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var observer: SwipeObserver
    
    @State var showQuit = false
        
    
    let invertedColorArray = ["White", "Yellow", "Light Blue", "Light Pink", "Light Gray", "Light Green"]
    
    
    var body: some View {
        
        ZStack {
            
            Color.primaryTeal
                .edgesIgnoringSafeArea(.all)
                .onAppear(perform: prepareHaptics)
            
            
            GeometryReader(content: geometricView(with:))
            
            
        }
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
        let geoHeight = geometry.size.height
        
        /*
         var textColor = Color(.white)
         if self.gameData.colorIndices.count > colorAtIndex {
         if invertedColorArray.contains(gameBrain.getColorGroup(index: self.gameData.colorIndices[colorAtIndex])) {
         textColor = Color(.darkGray)
         }
         }
         */
        
        var swatchHeight: CGFloat = 370
        
        if geoWidth > geoHeight {
            swatchHeight = min(geoHeight * 0.6, 390)
        } else {
            swatchHeight = min(geoWidth * 0.75, 450)    // 370
        }
        
        
        return Group {
            
            VStack(spacing: 0) {
                
             
                
                Spacer()
                
                /*
                 SwatchView(colorIndices: self.gameData.colorIndices,
                 colorAtIndex: colorAtIndex,
                 swatchHeight: swatchHeight,
                 colorName: gameBrain.getColorName(turn: colorAtIndex, indexArray: self.gameData.colorIndices),
                 company: gameBrain.getColorCompany(turn: colorAtIndex, indexArray: self.gameData.colorIndices),
                 colorURL: gameBrain.getColorURL(turn: colorAtIndex, indexArray: self.gameData.colorIndices),
                 coverOpacity: 0.0,
                 logoOpacity: self.showingColor ? 0.3 : 0.0,
                 nameOpacity: self.showingColor ? 1.0 : 0.0,
                 fontSize: self.fontSize,
                 showTurns: true)
                 */
                
                ZStack{
                    
                    
                    Image("Swatch This White")
                        .opacity(0.8)
                    
                    
                    ForEach(self.observer.tableSwatches) { swatch in
                        
                        
                        
                        SwatchView(colorIndices: self.gameData.colorIndices,
                                   colorAtIndex: swatch.turn,
                                   swatchHeight: swatchHeight,
                                   colorName: gameBrain.getColorName(turn: swatch.turn, indexArray: self.gameData.colorIndices),
                                   company: gameBrain.getColorCompany(turn: swatch.turn, indexArray: self.gameData.colorIndices),
                                   colorURL: gameBrain.getColorURL(turn: swatch.turn, indexArray: self.gameData.colorIndices),
                                   logoOpacity: self.showingColor ? 0.3 : 0.0,
                                   nameOpacity: self.showingColor && self.gameData.turnArray[0] == swatch.turn ? 1.0 : 0.0,
                                   fontSize: self.fontSize,
                                   showTurns: true)
                       //     .animation(.linear(duration: 0.1))
                            .gesture(DragGesture()
                                        .onChanged( { (value) in
                                            
                                            self.showingColor = false
                                            if self.gameData.turnArray[0] == swatch.turn {
                                                
                                                if value.translation.width > 0 {
                                                    
                                                    if value.translation.width > 30 {
                                                        self.observer.update(id: swatch, value: value.translation.width, degree: 6)
                                                    }
                                                    else{
                                                        self.observer.update(id: swatch, value: value.translation.width, degree: 0)
                                                    }
                                                }
                                                else{
                                                    
                                                    if value.translation.width < -30 {
                                                        self.observer.update(id: swatch, value: value.translation.width, degree: -6)
                                                    }
                                                    else{
                                                        self.observer.update(id: swatch, value: value.translation.width, degree: 0)
                                                    }
                                                }
                                                
                                            }
                                           
                                            
                                        }).onEnded( { (value) in
                                            
                                            if self.gameData.turnArray[0] == swatch.turn {
                                                if swatch.drag > 0 {
                                                    
                                                    if swatch.drag > swatchHeight/2.5 {
                                                        gameBrain.playSlideSoundEffect()
                                                        self.mildHaptics()
                                                        self.observer.update(id: swatch, value: geoWidth * 1.5, degree: 0)
                                                        self.gameData.turnArray[0] = self.gameData.turnArray[0] + 1
                                                    }
                                                    else{
                                                        self.observer.update(id: swatch, value: 0, degree: 0)
                                                    }
                                                }
                                                else{
                                                    
                                                    if -swatch.drag > swatchHeight/2.5 {
                                                        gameBrain.playSlideSoundEffect()
                                                        self.mildHaptics()
                                                        self.observer.update(id: swatch, value: geoWidth * -1.5, degree: 0)
                                                        self.gameData.turnArray[0] = self.gameData.turnArray[0] + 1
                                                    }
                                                    else{
                                                        
                                                        self.observer.update(id: swatch, value: 0, degree: 0)
                                                    }
                                                }
                                            }
                                            
                                           
                                            
                                        })
                            ).offset(x: swatch.drag)
                            .rotationEffect(.init(degrees:swatch.degree))
                            .animation(.spring())
                        
                    }
                    
                }
                
                Spacer()
                    .frame(height: 30)
                
                Spacer()
                
                
                ZStack(alignment: .center) {
                    
                    
                    Image("Paint Stripe")
                        .frame(width: geoWidth, alignment: .center) // height seems to have no effect
                        .rotationEffect(.degrees(180))
                      //  .offset(y: 30)

                    
                    HStack(alignment: .center) {
                        
                        if  (self.showQuit == false) {

                            if self.gameData.turnArray[0] > 0 {
                                Button(action: {
                                    
                                    self.mildHaptics()
                                    self.showingColor = false   // so the player can't see the next color name
                                    gameBrain.playSlideSoundEffect()

                                    
                                    // bring swatch back
                                    self.gameData.turnArray[0] = self.gameData.turnArray[0] - 1

                                    
                                    // swatches are in array in reverse order to turn to make them stack correctly
                                    var index = 0   //  turn 2
                                    if self.gameData.turnArray[0] == 1 {
                                        index = 1
                                    } else if self.gameData.turnArray[0] == 0 {
                                        index = 2
                                    }
                                    
                                    
                                    self.observer.update(id: self.observer.tableSwatches[index], value: 0, degree: 0)
                                    
                                }) {
                                    
                                    Image(systemName: "chevron.left")
                                        .font(Font.system(size: self.fontSize, weight: .bold))
                                        .frame(width: 60)
                                    
                                    
                                }
                                
                            } else {
                                
                                Button(action: {
                                    
                                    self.mildHaptics2()
                                    self.showQuit = true

                                }) {
                                    Text("Quit")
                                        .font(.system(size: self.fontSize))
                                        .frame(width: 60)
                                    
                                }
                            }
                            
                            
                            Spacer()
                            
                            
                            VStack(spacing: 30) {
                                
                                
                                Button(action: {
                                    
                                    self.mildHaptics()
                                    self.showingColor.toggle()
                                    
                                }) {
                                    if (self.showingColor == true) {
                                        
                                        Text("Hide \(colorLocalized) name")
                                            .font(.system(size: self.fontSize))
                                            .bold()
                                        
                                    } else {
                                        
                                        Text("Show \(colorLocalized) name")
                                            .font(.system(size: self.fontSize))
                                            .bold()
                                    }
                                    
                                }
                                .opacity(self.gameData.turnArray[0] < 3 ? 1 : 0)
                               // .animation(.linear(duration: 0.1))

                                
                                Button(action: {
                                    
                                    self.mildHaptics()
                                    self.showingHowTo.toggle()
                                }) {
                                    Text("How to play this mode")
                                        .font(.system(size: self.fontSize-4))
                                      //  .multilineTextAlignment(.center)
                                    
                                }
                                .sheet(isPresented: self.$showingHowTo) {
                                    HowToTabletopView()
                                }
                                
                                
                                
                                
                            }
                            
                            Spacer()
                            
                            
                            
                            if (self.gameData.turnArray[0] < 2) {   //  3 rounds in this mode
                                
                                Button(action: {
                                    
                                    self.strongHaptics()
                                    gameBrain.playSlideSoundEffect()

                                    self.showingColor = false   // so the player can't see the next color name
                                                                       

                                    // swatches are in array in reverse order to turn to make them stack correctly
                                    var index = 0   //  turn 2
                                    if self.gameData.turnArray[0] == 1 {
                                        index = 1
                                    } else if self.gameData.turnArray[0] == 0 {
                                        index = 2
                                    }
     
                                    
                                    self.observer.update(id: self.observer.tableSwatches[index], value: geoWidth * -1.5, degree: 0)
                                    
                                    // advance swatch
                                    self.gameData.turnArray[0] = self.gameData.turnArray[0] + 1
                                    
                                }) {
                                  
                                    Image(systemName: "chevron.right")
                                        .font(Font.system(size: self.fontSize, weight: .bold))
                                        .frame(width: 60)
                                }
                                
                            } else {
                                
                                Button(action: {
                                    
                                    self.mildHaptics2()
                                    
                                    self.showQuit = true
                                }) {
                                    Text("Quit")
                                        .font(.system(size: self.fontSize))
                                        .frame(width: 60)
                                }
                            
                        }
                        
                        } else {    // ask to confirm quit
                            
                            
                            VStack(spacing: 0) {
                                
                                Text("End game and return to menu?")
                                    .font(.system(size: self.fontSize))
                                    .padding()
                                
                                
                                HStack {
                                    
                                    Button(action: {
                                        
                                        self.mildHaptics()
                                        self.showQuit = false
                                        
                                    }) {
                                        Text("Cancel")
                                            .font(.system(size: self.fontSize))
                                            .padding()
                                    }
                                    
                                    
                                    Text("/")
                                        .font(.system(size: 23))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.primaryTeal)
                                    
                                    
                                    Button(action: {
                                        
                                        self.mildHaptics2()
                                        self.viewRouter.currentPage = "menu"
                                        gameBrain.considerShowingReviewPrompt()
                    
                                        
                                    }) {
                                        Text("Quit")
                                            .font(.system(size: self.fontSize))
                                            .padding()

                                        }
                                    
                                }
                            }
                        
                        }
                        
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 50, trailing: 10))
                        
                        
                    
                        
                }
                .frame(width: geoWidth, height: 100, alignment: .center)
                //   .edgesIgnoringSafeArea(.bottom)
                
                //   Spacer()
                
                
            }
            .accentColor(Color.tangerineText)

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
    
}
*/

class SwipeObserver: ObservableObject {
    
    @Published var tableSwatches = [Swatches]()
    @Published var last = -1
    
    
    init() {
        
        self.tableSwatches.append(Swatches(id: 2, drag: 0, degree: -4, turn: 2))
        self.tableSwatches.append(Swatches(id: 1, drag: 0, degree: 5, turn: 1))
        self.tableSwatches.append(Swatches(id: 0, drag: 0, degree: 0, turn: 0))
        
    }
    
    func update(id: Swatches, value: CGFloat, degree: Double){
        
        for i in 0..<tableSwatches.count{
            
            if tableSwatches[i].id == id.id {
                
                self.tableSwatches[i].drag = value
                self.tableSwatches[i].degree = degree
                self.last = i
            }
        }
    }
}


struct Swatches : Identifiable {
    
    var id: Int
    var drag: CGFloat
    var degree: Double
    var turn: Int
    
}
