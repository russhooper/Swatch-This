//
//  OnFirstAppearViewModifier.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import Foundation
import SwiftUI


struct OnFirstAppearModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
    
}


extension View {
    
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearModifier(perform: perform))
    }
}
