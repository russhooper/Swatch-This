//
//  AboutView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/10/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import CoreHaptics
import GameKit


struct AboutView: View {
    
    
    @State private var engine: CHHapticEngine?


    
    @State var userColorName: String = ""
    
    let rotationAngle: Double = Double.random(in: -5 ... 5)
    
    @Binding var isPresented: Bool
    
    @State var rotation1: Double = 0.0
    @State var rotation2: Double = 0.0
    @State var rotation3: Double = 0.0

    @State var showingCredits: Bool = false

    let creditsArray = [
        
        "Special thanks to:",
        "",
        "Paul Hudson",
        "Charley",
        "Lisa",
        "Mitch",
        "Santi",
        "Samantha",
        "Margherita",
        "Ana Luiza",
        "Sarah",
        "Lora",
        "Sierra",
        "Nikki"
    
    ]
    
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
        let geoHeight = geometry.size.height
        
        let swatchHeight: CGFloat = min(geoWidth * 0.55, 280)

        /*
        // Place the access point on the upper-left corner
        GKAccessPoint.shared.location = .bottomLeading
        GKAccessPoint.shared.isActive = true
        GKAccessPoint.shared.showHighlights = true
      //  GKAccessPoint.shared.parentWindow = AboutView.window
        */
        
        
        return Group {

            
            ZStack {
                
               
                
                Color.darkTealColor
                    .edgesIgnoringSafeArea(.all)
                
                
                                
                
                VStack(alignment: .center) {
                    
                    
                    
                    Text("Swatch This")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 50, leading: 20, bottom: 5, trailing: 20))
                    
                                        
                    Text("\(UIApplication.officialAppVersion ?? "Error finding version") (\(UIApplication.officialAppBuild ?? "error finding build"))")
                        .font(.body)
                        //  .fontWeight(.light)
                        .foregroundColor(.white)
                    //  .padding()
                    
                    
                    Spacer()
                    
                    ZStack {
                        
                        
                        VStack(alignment: .leading) {
                            ScrollView() {
                                ForEach(self.creditsArray, id: \.self) { line in
                                    
                                    Text(line)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)

                                }
                            }
                          //  .background(Color.moonlightColor)
                            .frame(width: swatchHeight+swatchHeight*0.13, height: swatchHeight, alignment: .center)
                        }
                        
                        
                        
                        SwatchStackView(swatchColor: Color.roseWineColor,
                                        swatchHeight: swatchHeight,
                                        text: "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 10,
                                        inGame: false,
                                        turnNumber: 0)
                            .offset(x: self.showingCredits ? geoWidth * 0.5 : 5,
                                    y: self.showingCredits ? geoHeight * -0.5 : -40)
                            .rotationEffect(.degrees(self.rotation1))
                            .animation(.easeOut)
                            .onAppear {
                                let baseAnimation = Animation.easeInOut(duration: 1)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            return withAnimation(baseAnimation) {
                                                self.rotation1 = -5.0
                                            }
                                        }
                            }
                        
                        SwatchStackView(swatchColor: Color.californiaBreezeColor,
                                        swatchHeight: swatchHeight,
                                        text: "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 10,
                                        inGame: false,
                                        turnNumber: 0)
                            .offset(x: self.showingCredits ? geoWidth * -0.5 : -15,
                                    y: self.showingCredits ? geoHeight * -0.5 : -6)
                            .rotationEffect(.degrees(self.rotation2))
                            .animation(.easeOut)
                            .onAppear {
                                let baseAnimation = Animation.easeInOut(duration: 1)

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            return withAnimation(baseAnimation) {
                                                self.rotation2 = -11.0
                                            }
                                        }
                            }
                        
                        SwatchStackView(swatchColor: Color.summerAfternoonColor,
                                        swatchHeight: swatchHeight,
                                        text: "",
                                        textField: nil,
                                        subtext: "",
                                        fontSize: 10,
                                        inGame: false,
                                        turnNumber: 0)
                            .offset(x: self.showingCredits ? geoWidth * 0.5 : 12,
                                    y: self.showingCredits ? geoHeight * -0.5 : -21)
                            .rotationEffect(.degrees(self.rotation3))
                            .animation(.easeOut)
                            .onAppear {
                                let baseAnimation = Animation.easeInOut(duration: 1)
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            return withAnimation(baseAnimation) {
                                                self.rotation3 = 15.0
                                            }
                                        }
                            }
                        
                        SwatchStackView(swatchColor: Color.sageColor,
                                        swatchHeight: swatchHeight,
                                        text: "A game by",
                                        textField: nil,
                                        subtext: "Russ Hooper",
                                        fontSize: 10,
                                        inGame: false,
                                        turnNumber: 0)
                            .offset(x: self.showingCredits ? geoWidth * 0.5 : 0,
                                    y: self.showingCredits ? geoHeight * 0.5 : 0)
                            .animation(.easeOut)

                    }
                    
                    
                    Spacer()
                    
                    
                    Button(action: {
                        
                        self.mildHaptics2()
                        self.showingCredits.toggle()
                        
                    }) {
                        
                        if self.showingCredits == true {
                            
                            Text("Hide credits")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                            
                        } else {
                            
                            Text("Show more credits")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        }
   
                    }
                    .padding()
            
                    
                    
                }
                
            }
            .frame(width: geoWidth,
                   height: geoHeight,
                   alignment: .center) // this fixes the confusing new iOS 14 SwiftUI alignment behavious. Alignment here should function as expected.
            
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


extension UIApplication {
    static var officialAppVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    static var officialAppBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}

/*
 struct AboutView_Previews: PreviewProvider {
 static var previews: some View {
 AboutView()
 }
 }
 */

