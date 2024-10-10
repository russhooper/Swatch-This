//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
// https://github.com/sudeepag/SAConfettiView

import UIKit
import QuartzCore
import SwiftUI



public class SAConfettiView: UIView {

    public enum ConfettiType {
        case confetti
        case triangle
        case star
        case diamond
        case image(UIImage)
    }

    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    public var type: ConfettiType!
    private var active :Bool!
    
    @EnvironmentObject var gameData: GameData

    var confettiAlreadyShown = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        
        
        colors = [
            /*
            UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
            UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
            UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
            UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
             UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
             */
            
            /*
            UIColor(red:255/255, green:155/255, blue:84/255, alpha:1.0),
            UIColor(red:255/255, green:155/255, blue:84/255, alpha:1.0),
            UIColor(red:0/255, green:84/255, blue:147/255, alpha:1.0),
            UIColor(red:1/255, green:199/255, blue:225/255, alpha:1.0),
            UIColor(red:225/255, green:117/255, blue:140/255, alpha:1.0),
            UIColor(red:252/255, green:255/255, blue:39/255, alpha:1.0)
 */
            
            
            UIColor(red:255/255, green:155/255, blue:84/255, alpha:1.0),    // cheerful tangerine
            UIColor(red:57/255, green:88/255, blue:101/255, alpha:1.0), // slate
            UIColor(red:249/255, green:83/255, blue:82/255, alpha:1.0), // red
            UIColor(red:234/255, green:255/255, blue:16/255, alpha:1.0), // lime green
          //  UIColor(red:166/255, green:242/255, blue:239/255, alpha:1.0), Moonrise yellow
            UIColor(red:252/255, green:209/255, blue:108/255, alpha:1.0) // amped up Moonrise blue
            
            
            
            
        ]
        
         
    //    let hexInt = gameBrain.getColorHex(turn: self.turnData.turnArray[0], indexArray: self.gameData.colorIndices)
            //   let hexc = UIColor(hex: "#\(hexInt)")!
   //     colors = [hexc]
   
        
        
      //  intensity = 0.75
        type = .confetti
        active = false
    }
    

    

    public func startConfetti() {
        
        intensity = 0.6
        
        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: -100.0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)

        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
          //  cells.append(defaultConfettiWithColor(color: color))

        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.stopConfetti()
        }
    }
    
    public func startSuperConfetti() {
        
        
        if confettiAlreadyShown == false {
            
            confettiAlreadyShown = true
            
            GameBrain().playWinSoundEffect()
            
            intensity = 1.0
            
            emitter = CAEmitterLayer()
            
            emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0.0)
            emitter.emitterShape = CAEmitterLayerEmitterShape.line
            emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
            
            var cells = [CAEmitterCell]()
            for color in colors {
                cells.append(confettiWithColor(color: color))
            }
            
            emitter.emitterCells = cells
            layer.addSublayer(emitter)
            active = true
            
            
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
                
                self.stopConfetti()
            }
            
        }
    }
    
    /*
    public func startSwatchConfetti() {
        
        intensity = 0.3
        
        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0.0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(swatchConfettiWithColor(color: color))
          //  cells.append(defaultConfettiWithColor(color: color))

        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.stopConfetti()
        }
    }
    */

    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }

    /*
    func imageForType(type: ConfettiType) -> UIImage? {

        var fileName: String!

        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case let .image(customImage):
            return customImage
        }

        let path = Bundle(for: SAConfettiView.self).path(forResource: "SAConfettiView", ofType: "bundle")
        let bundle = Bundle(path: path!)
        let imagePath = bundle?.path(forResource: fileName, ofType: "png")
        let url = URL(fileURLWithPath: imagePath!)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
        }
        return nil
        
    }
*/
    
    // the one we're using
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 500.0
        confetti.lifetimeRange = 0.0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(250.0)
        confetti.velocityRange = CGFloat(10.0)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(1.0)
        confetti.spin = CGFloat(1.75)
        confetti.spinRange = CGFloat(2.0)
        confetti.scaleRange = CGFloat(0.5)
        confetti.scaleSpeed = CGFloat(-0.05)
        confetti.contents = UIImage(named: "confetti.png")!.cgImage

        return confetti
    }
    
    /*
    func swatchConfettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 3.0 * intensity
        confetti.lifetime = 500.0
        confetti.lifetimeRange = 0.0
       // confetti.color = color.cgColor
        confetti.velocity = CGFloat(250.0)
        confetti.velocityRange = CGFloat(10.0)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(3.0)
        confetti.spin = CGFloat(0.5)
        confetti.spinRange = CGFloat(1.0)
        confetti.scaleRange = CGFloat(0.0)
        confetti.scaleSpeed = CGFloat(0.0)
        
        confetti.contents = UIImage(named: "swatch.png")!.cgImage

        return confetti
    }
    */
    
    func defaultConfettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        
        confetti.contents = UIImage(named: "confetti.png")!.cgImage

        return confetti
    }
    

    public func isActive() -> Bool {
    		return self.active
    }
}


struct SAConfettiSwiftUIView: UIViewRepresentable {

    let startConfettiBurst: Bool
    let confettiFrame: CGRect
    @EnvironmentObject var gameData: GameData

    
    func makeUIView(context: Context) -> SAConfettiView {
        return SAConfettiView(frame: confettiFrame)
    }

    func updateUIView(_ uiView: SAConfettiView, context: Context) {
        startConfettiBurst ? uiView.startConfetti() : uiView.stopConfetti()
    }
}



struct SASuperConfettiSwiftUIView: UIViewRepresentable {

    let startSuperConfettiBurst: Bool
    let confettiFrame: CGRect
    @EnvironmentObject var gameData: GameData

    
    func makeUIView(context: Context) -> SAConfettiView {
        return SAConfettiView(frame: confettiFrame)
    }

    func updateUIView(_ uiView: SAConfettiView, context: Context) {
        startSuperConfettiBurst ? uiView.startSuperConfetti() : uiView.stopConfetti()
    }
}


/*
struct SASwatchConfettiSwiftUIView: UIViewRepresentable {

    let startSwatchConfetti: Bool
    let confettiFrame: CGRect
    @EnvironmentObject var gameData: GameData

    
    func makeUIView(context: Context) -> SAConfettiView {
        return SAConfettiView(frame: confettiFrame)
    }

    func updateUIView(_ uiView: SAConfettiView, context: Context) {
        startSwatchConfetti ? uiView.startSwatchConfetti() : uiView.stopConfetti()
    }
}
*/


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

      if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])

                if hexColor.count == 8 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        a = CGFloat(hexNumber & 0x000000ff) / 255

                        self.init(red: r, green: g, blue: b, alpha: a)
                        return
                    }
                }
            }

        return nil
    }
}
