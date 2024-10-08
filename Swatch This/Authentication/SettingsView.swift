//
//  SettingsView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/2/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State var displayName: String = (LocalUser.shared.displayName ?? "")
    @FocusState private var isFocused: Bool
    @AppStorage("userPrefersDarkMode") var userPrefersDarkMode: Bool = false

    let appIcons: [String] = ["AppIcon"] // from Assets


    var body: some View {
        
        
        List {
            
            Section(header: Text("Display name")) {
                VStack {
                    TextField("What's your name?", text: $displayName)
                    //   .frame( alignment: .leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isFocused)

                    HStack {
                        
                        Button("Save") {
                            
                            LocalUser.shared.displayName = displayName.profanityFiltered()
                            
                            isFocused = false
                            
                            Task {
                                do {
                                    // update displayName
                                    try await UserManager.shared.updateUserDisplayName(displayName: displayName.profanityFiltered())
                                    
                                } catch {
                                    print("error updating displayName: \(error)")
                                }
                                
                            }
                 
                        }
                        .disabled(!isFocused || displayName.containsProfanity() || displayName.profanityFiltered().count < 3 || displayName.profanityFiltered().count > 20)

                        
                        Spacer()
                    }
                    
                }
            }
            
            
            Section(header: Text("Account actions")) {

                
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
            }
            
            
            if settingsViewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
            
            Section(header: Text("App icon")) {
                HStack {
                    ForEach(appIcons, id: \.self) { name in
                        Button {
                            UIApplication.shared.setAlternateIconName(name)
                        } label: {
                            Image("AppIcon")
                        }
                    }
                }
            }
            
            Section(header: Text("Dark mode")) {
                HStack {
                    Toggle("Dark Mode", isOn: $userPrefersDarkMode)
                }
            }
            
        }
        
        
        .onAppear {
            settingsViewModel.loadAuthProviders()
            settingsViewModel.loadAuthUser()
            
            displayName = LocalUser.shared.displayName ?? ""
            print("displayName: \(displayName)")
        }
        .navigationBarTitle("Settings")
        
    }
}
/*
 #Preview {
 //  NavigationStack {
 SettingsView(showSignInView: .constant(true))
 //  }
 }
 */

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
        
        Section(header: Text("Link account")) {

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
        }
        
        
    }
}
