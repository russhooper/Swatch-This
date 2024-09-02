//
//  HowToView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/10/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics
import GameKit


struct HowToView: View {
    
    @State private var engine: CHHapticEngine?
    
    
    let swatchPaddingX: CGFloat = 20
    let swatchPaddingY: CGFloat = 70
    
    
    @State var userColorName: String = ""
    
    let rotationAngle: Double = Double.random(in: -5 ... 5)
    
    
    @Binding var isPresented: Bool
    
    
    
    var body: some View {
        
        
        GeometryReader(content: geometricView(with:))
            .onAppear(perform: {
                GKAccessPoint.shared.isActive = false
                prepareHaptics()
            })
            .onDisappear(perform: {
                GKAccessPoint.shared.isActive = true
            })
        
        
    }
    
    
    func geometricView(with geometry: GeometryProxy) -> some View {
        
        let geoWidth = geometry.size.width
      
        let tangerineColorText: UInt32 = 0xFA9343

        
        
        
        return Group {
            
            ZStack {
                
                /*
                Color(red: 250/255, green: 250/255, blue: 250/255, opacity: 1)  //  off-white
                    .edgesIgnoringSafeArea(.all)
                
                Color(red: 243/255, green: 233/255, blue: 214/255, opacity: 1)  //  Ceylon Cream
                    .edgesIgnoringSafeArea(.all)
                
                Color(red: 250/255, green: 243/255, blue: 228/255, opacity: 1)  //  Mayonnaise
                    .edgesIgnoringSafeArea(.all)
                */
                
                Color(.white)
                    .edgesIgnoringSafeArea(.all)

                
                ScrollView {
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        
                        
                        scrollViewContent(swatchHeight: 230.0, geoWidth: geoWidth)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                       
                                                
                        
                        Button(action: {
                            
                            self.mildHaptics2()
                            
                            self.isPresented = false
                            
                        }) {
                            Text("Dismiss")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                        }
                        .padding()
                        
                        
                    }
                    .accentColor(Color(tangerineColorText))
                    .frame(width: geoWidth)
                    
                }
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


struct scrollViewContent: View {
    
    let swatchHeight: CGFloat
    let geoWidth: CGFloat

    let sunnySideUp: UInt32 = 0xF9AB1D
    let sweetSixteen: UInt32 = 0xF29FAB
    let jamaicaBay: UInt32 = 0x34A3B6
    let babySealBlack: UInt32 = 0x474B51
    let grayFlannel: UInt32 = 0x585861
    let darkGreenColor: UInt32 = 0x395865
    let alohaColor: UInt32 = 0x20B396
    
    
    var rand1 = Double.random(in: -6 ..< -3)

    
    
    
    var body: some View {
        
        
        Group {
            
            ZStack {
                
                Image("Blue Paint")
                
                Text("How to play Swatch This")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                    .frame(width: geoWidth, height: 150, alignment: .center)

            }
            
            
            Text("Have you ever looked at paint \(colorLocalized) names?")
                .font(.title3)
                .padding()
            
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: self.swatchHeight))], spacing: 20) {
                 
                
                Group {
                    
                    
                    Text("This isn't just \"yellow,\" it's...")
                        .font(.title3)

                    SwatchStackView(color: self.sunnySideUp,
                                    swatchHeight: self.swatchHeight,
                                    text: "Sunny Side Up",
                                    textField: nil,
                                    subtext: "by Behr",
                                    fontSize: 10,
                                    inGame: false,
                                    turnNumber: 0)
                        .rotationEffect(.degrees(Double.random(in: -5 ..< -1)))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                }
                
                
                Group {
                    
                    Text("This isn't just \"pink,\" it's...")
                        .font(.title3)

                    SwatchStackView(color: self.sweetSixteen,
                                    swatchHeight: self.swatchHeight,
                                    text: "Sweet Sixteen",
                                    textField: nil,
                                    subtext: "by Valspar",
                                    fontSize: 10,
                                    inGame: false,
                                    turnNumber: 0)
                        .rotationEffect(.degrees(Double.random(in: 1 ..< 5)))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                    
                }
                
                Group {
                    
                    Text("This isn't just \"blue,\" it's...")
                        .font(.title3)

                    SwatchStackView(color: self.jamaicaBay,
                                    swatchHeight: self.swatchHeight,
                                    text: "Jamaica Bay",
                                    textField: nil,
                                    subtext: "by Sherwin-Williams",
                                    fontSize: 10,
                                    inGame: false,
                                    turnNumber: 0)
                        .rotationEffect(.degrees(Double.random(in: -5 ..< -1)))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                    
                }
                
                Group {
                    
                    Text("Your turn! What would you call this?")
                        .font(.title3)

                    SwatchStackView(color: self.alohaColor,
                                    swatchHeight: self.swatchHeight,
                                    text: "",
                                    textField: nil,
                                    subtext: "",
                                    fontSize: 10,
                                    inGame: false,
                                    turnNumber: 0)
                        .rotationEffect(.degrees(Double.random(in: 1 ..< 5)))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                    
                }
                
                
            }

            ZStack {
                
                Image("Blue Paint")
                
                Text("The goal of Swatch This is to make up the best names for \(colorLocalized)s.")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: geoWidth, height: 250, alignment: .center)

            }
            
           
            
            Text("All players will be shown the same \(colorLocalized) swatch, with its real name hidden. Everyone will make up a name they think describes the \(colorLocalized). Then a list of these (with the real name included) will be shown. Guess the real name and you'll get points. And should someone guess your \(colorLocalized) name, you’ll get points for that too!")
                .font(.body)
                .padding()
            
            Text("Game Center is used for online matches. To play with a specific person online, add them as a friend in Game Center.")
                .font(.body)
                .padding()

        }
    }
    
   
    
    
}



/*
 struct HowToView_Previews: PreviewProvider {
 static var previews: some View {
 HowToView()
 }
 }
 */

