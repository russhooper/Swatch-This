//
//  AuthenticationView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//


import SwiftUI
import GoogleSignIn
import GoogleSignInSwift


struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        VStack{
                        
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInAnonymous()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
                
            }, label: {
                Text("Sign in anonymously")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.orange)
                    .cornerRadius(10)
            })
            
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            
            // Apple sign in button
            Button(action: {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
                
            }, label: {
                // we need the image of the SignIn button inside of a SwiftUI button where we can access the press result
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false) // set SignIn button to basically just be the image inside of the SwiftUI button
            })
            .frame(height: 55)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}


#Preview {
   AuthenticationView(showSignInView: .constant(false))
 }

/*
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
*/
