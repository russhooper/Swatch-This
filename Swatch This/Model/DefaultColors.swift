//
//  DefaultColors.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/16/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

/*
// come from colors in Assets
extension Color {
    
    static let darkGreenColor = Color("darkGreenColor")
    static let primaryTealColor = Color("primaryTealColor")
    static let babySealBlackColor = Color("babySealBlackColor")
    static let blushColor = Color("blushColor")
    static let californiaWineColor = Color("californiaWineColor")
    static let denimColor = Color("denimColor")
    static let grayFlannelColor = Color("grayFlannelColor")
    static let mercuryColor = Color("mercuryColor")
    static let roseWineColor = Color("roseWineColor")
    static let tangerineColor = Color("tangerineColor")
    static let tangerineTextColor = Color("tangerineTextColor")
    static let sunnySideUpColor = Color("sunnySideUpColor")
    static let jamaicaBayColor = Color("jamaicaBayColor")
    static let alohaColor = Color("alohaColor")
    static let sweetSixteenColor = Color("sweetSixteenColor")
    static let darkTealColor = Color("darkTealColor")
    static let californiaBreezeColor = Color("californiaBreezeColor")
    static let summerAfternoonColor = Color("summerAfternoonColor")
    static let sageColor = Color("sageColor")
    static let moonlightColor = Color("moonlightColor")
    static let wetCementColor = Color("wetCementColor")
    static let charcoalColor = Color("charcoalColor")
    static let mediumTealColor = Color("mediumTealColor")
    static let howToColor = Color("howToColor")


}
*/

extension Color {
    init(hex: UInt32) {
        let red = Double((hex & 0xFF0000) >> 16) / 255
        let green = Double((hex & 0x00FF00) >> 8) / 255
        let blue = Double(hex & 0x0000FF) / 255
        
        self.init(red: red, green: green, blue: blue)
    }
}
