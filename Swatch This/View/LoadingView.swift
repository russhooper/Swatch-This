//
//  LoadingView.swift
//  Swatch This
//
//  Created by Russ Hooper on 8/8/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
   
    let blushColor: UInt32 = 0xf95352

    
    var body: some View {
        ZStack {
            
            Color(brightTealColor)
                .edgesIgnoringSafeArea(.all)
            

            Image("Paint Stripe")

                .frame(height: 350, alignment: .center)
                .rotationEffect(.degrees(20))


            
            VStack(alignment: .center) {
                
                
                Spacer()
                
                Text("Loading")
                    .font(.system(size: 30))
                    .foregroundColor(Color(brightTealColor))
                    .multilineTextAlignment(.center)
                
                ActivityIndicator()
                    .padding()
                                
                Button(action: {
                    
                    
                    self.viewRouter.currentPage = "menu"
                    
                }) {
                    Text("Quit")
                        .font(.system(size: 24))

                }
                
                Spacer()
            }
        }
        .accentColor(Color(DefaultColors.shared.tangerineColorText))

    }
}


struct ActivityIndicator: UIViewRepresentable {
    
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        // Create UIActivityIndicatorView
        
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        // Start the UIActivityIndicatorView animation
        
        uiView.startAnimating()
        
    }
    
    
}



struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}


