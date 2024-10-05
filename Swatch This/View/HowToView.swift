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
                
                Color(.howTo)
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
                    .accentColor(Color.tangerineTextColor)
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

    
    var rand1 = Double.random(in: -6 ..< -3)

    
    
    
    var body: some View {
        
        
        Group {
            
            ZStack {
                
                Image("Blue Paint")
                
                Text("How to play Swatch This")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
               //     .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                    .padding()
                    .frame(width: geoWidth, height: 150, alignment: .center)

            }
            
            
            Text("Have you ever looked at paint \(colorLocalized) names?")
                .font(.title2)
                .padding()
            
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: self.swatchHeight))], spacing: 20) {
                 
                
                Group {
                    
                    
                    Text("This isn't just \"yellow,\" it's...")
                        .font(.title2)

                    SwatchStackView(swatchColor: Color.sunnySideUpColor,
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
                        .font(.title2)

                    SwatchStackView(swatchColor: Color.sweetSixteenColor,
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
                        .font(.title2)

                    SwatchStackView(swatchColor: Color.jamaicaBayColor,
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
                        .font(.title2)

                    SwatchStackView(swatchColor: Color.alohaColor,
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
                    .frame(width: geoWidth, height: 200, alignment: .center)

            }
            
           
            
            Text("All players will be shown the same \(colorLocalized) swatch, with its real name hidden.\n\nEveryone will make up a name they think describes the \(colorLocalized). Then a list of these will be shown, with the real name mixed in.\n\nGuess the real name and you'll get points. And should someone guess your \(colorLocalized) name, you’ll get points for that too!")
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

