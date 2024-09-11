//
//  SettingsView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI


struct SettingsView: View {
    
    @StateObject private var settingsViewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try settingsViewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                        
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await settingsViewModel.deleteAccount()
                        // need to ask for conformation and re-authorize user to delete. Would also need to delete them from the Firestore database
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
                
            } label: {
                Text("Delete account")
            }
            
            if settingsViewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
        }
        .onAppear {
            settingsViewModel.loadAuthProviders()
            settingsViewModel.loadAuthUser()
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
  //  NavigationStack {
        SettingsView(showSignInView: .constant(true))
  //  }
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
    
    private var anonymousSection: some View {
        
        Section {
            
            Button("Link Google account") {
                Task {
                    do {
                        try await settingsViewModel.linkGoogleAccount()
                        print("Google linked")
                    } catch {
                        print(error)
                        
                    }
                }
            }
            
            Button("Link Apple account") {
                Task {
                    do {
                        try await settingsViewModel.linkAppleAccount()
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
