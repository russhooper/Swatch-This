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
    
    let appIcons: [String] = []
    // https://www.hackingwithswift.com/example-code/uikit/how-to-change-your-app-icon-dynamically-with-setalternateiconname
    
    var body: some View {
        

                List {
                    
                    displayNameSection()
                    
                    appIconSection()
                    
                    darkModeSection()
                    
                    if settingsViewModel.authUser?.isAnonymous == true {
                        anonymousSection
                    }
                    
                    accountActionsSection()

                }
                
            
    
        
        .onAppear {
            settingsViewModel.loadAuthProviders()
            settingsViewModel.loadAuthUser()
            
            displayName = LocalUser.shared.displayName ?? ""
            print("displayName: \(displayName)")
        }
        .navigationBarTitle("Settings")
        
    }
    
    
    func displayNameSection() -> some View {
        return Group {
            
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
                        .tint(Color.tangerineText)
                        
                        Spacer()
                    }
                    
                }
            }
        }
    }
    
    func appIconSection() -> some View {
        
        return Group {
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
        }
    }
    
    func darkModeSection() -> some View {
        
        return Group {
            
            Section(header: Text("Appearance")) {
                    
                Button(action: {
                    if userPrefersDarkMode == true {
                        userPrefersDarkMode.toggle()
                    }
                }, label: {
                    AppearanceStyleRowView(appearanceStyle: "Light", showSelected: !userPrefersDarkMode)
                     //   .disabled(userPrefersDarkMode == false)
                })
                
                Button(action: {
                    userPrefersDarkMode.toggle()
                }, label: {
                    AppearanceStyleRowView(appearanceStyle: "System", showSelected: !userPrefersDarkMode)
                     //   .disabled(userPrefersDarkMode == false)
                })
                
                Button(action: {
                    if userPrefersDarkMode == false {
                        userPrefersDarkMode.toggle()
                    }
                }, label: {
                    AppearanceStyleRowView(appearanceStyle: "Dark", showSelected: userPrefersDarkMode)
                     //   .disabled(userPrefersDarkMode == false)
                })
                    

                    
                    /*
                    Button() {
                      //  userPrefersDarkMode.toggle()
                    } label: {
                        Text("System")
                        Image(systemName: userPrefersDarkMode ? "largecircle.fill.circle" : "circle")
                    }
                    
                    
                    
                    Button() {
                    //    if userPrefersDarkMode == false {
                       //     userPrefersDarkMode.toggle()
                     //   }
                    } label: {
                        Text("Dark mode")
                        Image(systemName: userPrefersDarkMode ? "largecircle.fill.circle" : "circle")
                    }
                  //  .disabled(userPrefersDarkMode == true)
*/
                
                }
          //  .tint(Color.tangerineText)

        }
    }
    
    
    
    func accountActionsSection() -> some View {
        
        return Group {
            
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
            
        }
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
