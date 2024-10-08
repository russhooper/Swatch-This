//
//  MatchesView.swift
//  Swatch This
//
//  Created by Russ Hooper on 9/5/24.
//  Copyright © 2024 Radio Silence. All rights reserved.
//

import SwiftUI

struct MatchesView: View {
    
    @StateObject private var viewModel = MatchesViewModel()
    @State private var matchPassword: String = ""
    @State var incorrectPassword: Int = 0
    @FocusState private var isFocused: Bool
    @EnvironmentObject var viewRouter: ViewRouter
    // @EnvironmentObject var gameData: GameData
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                                
                List {
                    
                     //   Spacer()
                    //        .frame(height: 30)
                    
                    Image("Blue Paint 2")
                    // should maybe swap this out with a listener for all matches and then filter here with .filter { $0.isCompleted }
                    // though, it'll be good to have the current match listener stay active outside of this view. We don't need the completed matches
                    // listener to stay active
                    
                    currentMatchesSection()
                    
                    joinMatchSection()
                    
                    createMatchSection()
                    
                    
                    Section(header: Text("Completed Matches")) {
                        ForEach(viewModel.userCompletedMatches, id: \.id.self) { item in
                            Text("item.isCompleted: \(item.isCompleted)")
                        }
                    }
                    
                }
                .navigationTitle("Matches")
                .scrollContentBackground(.hidden)
                .background(Color.listBackground)
            }
            
            
            backToMenuSection()
               // .frame(height: 60)
                .background(.thinMaterial)
        }
        
        .onFirstAppear {
            //  viewModel.getMatches()
            
            viewModel.addListenerForActiveMatches()
            viewModel.addListenerForCompletedMatches()
            
        }
    }
    
    
    func backToMenuSection() -> some View {
        
        return Group {
            
            HStack {
                
                Button(action: {
                    
                    //   self.mildHaptics2()
                    
                    self.viewRouter.currentPage = "menu"
                    
                    
                }) {
                    HStack {
                        Image(systemName: "arrowtriangle.backward.fill")
                        Text("Menu")
                    }
                    .font(.system(size: 18))
                    .foregroundColor(Color.tangerineText)
                    .bold()
                    
                }
                .padding()
                
                
                Spacer()
                
            }
        }
    }
    
    func currentMatchesSection() -> some View {
                
        return Group {
            
            Section(header: Text("Current Matches")) {
                ForEach(viewModel.userActiveMatches, id: \.id.self) { userMatch in
                    Button(action: {
                        
                        if userMatch.canTakeTurn == true {
                            Task {
                                do {
                                    let match = try await MatchesManager.shared.getMatch(matchID: userMatch.matchID)
                                    MatchesManager.shared.joinMatch(match: match)
                                    viewRouter.currentPage = "game"
                                    
                                } catch {
                                    print("error joining match: \(error)")
                                }
                            }
                        } else {
                            
                            MatchData.shared.match = userMatch.match
                            viewRouter.currentPage = "otherTurn"
                        }
                        
                        
                    }, label: {
                        ActiveMatchCellView(userMatch: userMatch, rotations: [-25, -10, 0, 10], offsetsY: [10, 0, -5, -2])
                    })
                    .frame(height: 90)
                    .listRowBackground(
                        // The background with gradient fill
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(
                                
                                LinearGradient(gradient:
                                                Gradient(colors: (userMatch.canTakeTurn ?? false) ? [Color.tangerineText, Color.tangerineGradient] : [Color.primaryTeal, Color.primaryTeal]),
                                               startPoint: .leading,
                                               endPoint: .topTrailing)
                            )
                            .padding(.top, 10)
                    )
                    /*
                     .overlay(
                     RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.babySealBlack, lineWidth: 1)
                     .frame(height: 100)
                     .padding(.top, 10)
                     )
                     */
                    .listRowSeparator(.hidden)
                    
                }
            }
        }
    }
    
    func joinMatchSection() -> some View {
        return Group {
            
            Section(header: Text("Join Match")) {
                
                VStack {
                    TextField("Enter match code", text: $matchPassword)
                    //   .frame( alignment: .leading)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .fontWeight(.heavy)
                        .focused($isFocused)
                        .modifier(Shake(animatableData: CGFloat(self.incorrectPassword)))
                    
                    HStack {
                        
                        Button("Join") {
                            
                            Task {
                                do {
                                    if let matchesForPassword = try await MatchesManager.shared.checkMatchCode(password: matchPassword) {
                                        print("matchesForPassword: \(matchesForPassword)")
                                        
                                        //join the match
                                        self.incorrectPassword = 0
                                        MatchesManager.shared.joinMatch(match: matchesForPassword.first!) // if there are multiple, that's bad -- we'll just pick the first. Using !, which is also bad -- but can it get to this point if nil?
                                        self.viewRouter.currentPage = "game"
                                        
                                    } else {
                                        handleIncorrectPassword()
                                    }
                                    
                                } catch {
                                    handleIncorrectPassword()
                                    print("passwordCheck error")
                                }
                            }
                            
                            
                            isFocused = false
                            
                        }
                        .disabled(!isFocused || matchPassword.containsProfanity() || matchPassword.count < 2)
                        .bold()

                        Spacer()
                    }
                    
                }
                
            }
            .listRowBackground(Color.pinkDamask)
        }
    }
    
    func createMatchSection() -> some View {
        return Group {
            Section(header: Text("Create Match")) {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                        MatchesManager.shared.createMatch()
                        
                        self.viewRouter.currentPage = "game"
                        
                        
                        
                    }, label: {
                        Image(systemName: "plus")
                            .tint(.white)
                            .font(.headline)
                            .padding(.horizontal, 30)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color.tangerineText)
                    
                    Spacer()
                    
                }
                
            }
            .listRowBackground(Color.pinkDamask)
        }
    }
    
    // Helper function to handle incorrect password logic
    func handleIncorrectPassword() {
        withAnimation(.default) {
            self.incorrectPassword += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.incorrectPassword = 0
        }
    }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}



#Preview {
    MatchesView()
}
