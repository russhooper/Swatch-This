//
//  SettingsView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI


struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                        
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        // need to ask for conformation and re-authorize user to delete. Would also need to delete them from the Firestore database
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
                
            } label: {
                Text("Delete account")
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}


//
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            SettingsView(showSignInView: .constant(false))
//        }
//    }
//}

extension SettingsView {
    
    private var emailSection: some View {
        
        Section {
            
            Button("Reset password") {
                Task {
                    do {
                        print("Password reset")
                    }
                }
            }
            
            Button("Update password") {
                Task {
                    do {
                        print("Password updated")
                    }
                }
            }
            
            Button("Update email") {
                Task {
                    do {
                        print("Email updated")
                    }
                }
            }
        } header: {
            Text("Email functions")
        }
        
        
    }
    
    private var anonymousSection: some View {
        
        Section {
            
            Button("Link Google account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Google linked")
                    } catch {
                        print(error)
                        
                    }
                }
            }
            
            Button("Link Apple account") {
                Task {
                    do {
                     //   try await viewModel.linkAppleAccount()
                        print("Apple linked")
                    } catch {
                        print(error)
                        
                    }
                }
            }
        } header: {
            Text("Create account")
        }
        
        
    }
}
