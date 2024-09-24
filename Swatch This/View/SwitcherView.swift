//
//  SwitcherView.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/22/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import SwiftUI
import GameKit


var errorAlertTitle = "Error"
var errorAlertMessage = "Error"


struct AlertId: Identifiable {
    
    var id: AlertType
    
    enum AlertType {
        case typeTurn
        case typeUpdate
        case typeGameCenter
    }
    
    var match: GKTurnBasedMatch?
}


struct SwitcherView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var gameData: GameData
    @EnvironmentObject var transitionSwatches: TransitionSwatches

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var turnData: TurnData = TurnData()
    @State var gameBrain = GameBrain()
    
    @State private var showingTurnAlert: Bool = false
    @State private var showingUpdateAlert: Bool = false
    @State private var showingGameCenterAlert: Bool = false
    @State private var showSignInView: Bool = false

    
    @State var alertId: AlertId?
    
    var matchForAlert: GKTurnBasedMatch? = nil
    
    
    let presentGamePub = NotificationCenter.default
        .publisher(for: NSNotification.Name("presentGame"))
    
    let rematchPub = NotificationCenter.default
        .publisher(for: NSNotification.Name("rematchNotification"))
    
    let menuPub = NotificationCenter.default
        .publisher(for: NSNotification.Name("returnToMenu"))
    
    let yourTurnAlert = NotificationCenter.default
        .publisher(for: NSNotification.Name("yourTurnAlert"))
    
    let gameCenterAlert = NotificationCenter.default
        .publisher(for: NSNotification.Name("gameCenterAlert"))
    

    
    
    @State var colorIndices: [Int] = [
        0
    ]
        
    
    // @StateObject var storeManager = StoreManager()
    
    
    var body: some View {
        
        ZStack {
            if self.viewRouter.currentPage == "menu" {
                
                MenuView(gameData: self.resetGameData())
                
                
             //       AnimationPlayground5()
              //  GameEndView(gameData: self.gameData, turnData: self.turnData, selection: nil)
                
                
            } else if self.viewRouter.currentPage == "tabletop" {
                
                tabletopGroup()
                
            } else if self.viewRouter.currentPage == "game" {
                
                gameGroup()
                
            }
            
            else if self.viewRouter.currentPage == "loading" {
                
                // show a loading screen while the Game Center view and the data are being loaded
              //  LoadingView()
                
                MatchesView()
                
            }
            
            else if self.viewRouter.currentPage == "otherTurn" { // cannot take turn. Triggered here if user tries to enter game before it's their first turn
                
                OtherPlayersTurn(colorIndices: self.gameData.colorIndices, rotations: self.gameBrain.generate4Angles())
                    .environmentObject(ViewRouter.sharedInstance)
                   // .transition(.move(edge: .trailing))
                
            }
            
        }
        .alert(item: $alertId) { (alertId) -> Alert in
            return createAlert(alertId: alertId)
        }
        .accentColor(Color(DefaultColors.shared.tangerineColorText))
        .onReceive(presentGamePub) { output in
            self.presentGame(output)
        }
        .onReceive(rematchPub) { output in
            self.rematch(output)
        }
        .onReceive(menuPub) { output in
            self.returnToMenu()
        }
        .onReceive(yourTurnAlert) { output in
            //    self.showingTurnAlert = true
            self.alertId = AlertId(id: .typeTurn)
        }
        .onReceive(gameCenterAlert) { output in
            //   self.showingGameCenterAlert = true
            self.alertId = AlertId(id: .typeGameCenter)
        }
        .onAppear {
            if let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()  {
                print("authUser: \(String(describing: authUser.uid))")
                showSignInView = false
                                                
            } else {
                showSignInView = true
            }

           // print("showSignInView: \(showSignInView)")
        }
        .task {
            try? await UserManager.shared.loadCurrentUser()
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)

            }
        }
        
    }
    
    
    func tabletopGroup() -> some View {
        
        return Group {
            
            if self.gameData.colorIndices == [0,0,0,0] {    // if the data is the defaults, we'll create a new game
                PenPaperView(gameData: self.generateNewGameDataReturn(indiciesCount: 3, // Tabletop is more tiring than online or pass & play, so we'll do only 3 colors
                                                                      localRematch: false))
                    .environmentObject(SwipeObserver())
                    .transition(.move(edge: .trailing))
                    .onAppear {
                        // this game mode involves the device sitting in the middle of a table with no input for a while
                        // we want the players to be able to see the color the whole time, so we'll disable screen auto-lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    .onDisappear {
                        // and then renable it when we leave this mode
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
                
            } else { // if there is non-default data, we assume it was from this game (since it should've been reset otherwise) and we'll resume
                PenPaperView(gameData: self.gameData)
                    .environmentObject(SwipeObserver())
                    .transition(.move(edge: .trailing))
                    .onAppear {
                        // this game mode involves the device sitting in the middle of a table with no input for a while
                        // we want the players to be able to see the color the whole time, so we'll disable screen auto-lock
                        UIApplication.shared.isIdleTimerDisabled = true
                    }
                    .onDisappear {
                        // and then renable it when we leave this mode
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
                
            }
        }
    }
    
    
    
    func gameGroup() -> some View {
        
        return Group {
            
            if self.gameData.isComplete == true {
                
                // set default selection, but only in a split view (which occurs in the .regular size)
                if self.horizontalSizeClass == .regular {
                    
                    GameEndView(gameData: self.gameData, turnData: self.turnData, selection: self.gameData.sortedPlayersArray[0])
                     //   .environmentObject(TransitionSwatches())
                       
                    // no slide transition for iPad
                    
                    
                } else {    // iPhone or iPad in split view
                    
                    GameEndView(gameData: self.gameData, turnData: self.turnData, selection: nil)
                        .transition(.move(edge: .trailing))

                }
                
            } else {    // match not complete
                
                
                if self.viewRouter.onlineGame == false {
                    
                    if self.gameData.colorIndices == [0,0,0,0] { // if the data is the defaults, we'll create a new game
                       
                        ContentView(gameData: self.generateNewGameDataReturn(indiciesCount: 4, localRematch: false),
                                    turnData: self.resetTurnData(),
                                    playerCount: self.viewRouter.playerCount,
                                    onlineGame: false,
                                    colorIndices: self.gameData.colorIndices,
                                    playDealAnimation: false)   // should match onlineGame
                        
                    } else { // if there is non-default data, we assume it was from this game (since it should've been reset otherwise) and we'll resume
                        
                        
                        
                        if gameBrain.isSubmissionEnd(roundsFinished: self.turnData.turnArray[1],
                                                     playerCount: self.viewRouter.playerCount)  {
                            
                            // color submissions are done
                            
                            GuessColorsView(gameData: self.gameData,
                                            turnData: self.turnData,
                                            playerCount: self.viewRouter.playerCount,
                                            viewRouter: self._viewRouter)
                             //   .environmentObject(TransitionSwatches())

                            
                        } else {
                            
                            // submission stage of the match
                            
                            ContentView(gameData: self.gameData,
                                        turnData: self.turnData,
                                        playerCount: self.viewRouter.playerCount,
                                        onlineGame: false,
                                        colorIndices: self.gameData.colorIndices,
                                        playDealAnimation: false) // should match onlineGame
                            
                        }
                    }
                    
                    
                } else {
                    
                    // online match
                    
                 //   if self.turnData.showingTransition == true {
                        
                        // in color creation phase
                        if gameBrain.isSubmissionEnd(roundsFinished: self.gameData.turnArray[1],
                                                     playerCount: self.viewRouter.playerCount) == false {
                            
                            
                            NameColorsView(turnData: self.turnData,
                                        playerCount: self.viewRouter.playerCount,
                                        playDealAnimation: true) // should match onlineGame
                            
                            
                            
                            
                        } else {    // in guess color phase
                            
                            GuessColorsView(gameData: self.gameData,
                                            turnData: self.turnData,
                                            playerCount: self.viewRouter.playerCount,
                                            viewRouter: self._viewRouter)
                           //     .environmentObject(TransitionSwatches())

                            
                        }
                        
                    
                    /*
                    } else {    // cannot take turn
                        
                        
                        OtherPlayersTurn(colorIndices: self.gameData.colorIndices, rotations: self.gameBrain.generate4Angles())
                            .environmentObject(ViewRouter.sharedInstance)
                          //  .transition(.move(edge: .trailing))
                        
                    }
                     */
                }
                
                
            }
            
            
            
            
        }
        
    }
    
    
    private func createAlert(alertId: AlertId) -> Alert {
        switch alertId.id {
        
        case .typeTurn:
            let primaryButton = Alert.Button.default(Text("Play")) {
                
                self.loadAndDisplay(loadedMatch: alertId.match!)
                
                print("primary button pressed")
            }
            let secondaryButton = Alert.Button.cancel(Text("Dismiss")) {
                print("secondary button pressed")
            }
            return Alert(title: Text("It's your turn in a match!"),
                         message: Text("You can also see all current matches by tapping Play Online in the menu."),
                         primaryButton: primaryButton,
                         secondaryButton: secondaryButton)
            
        case .typeUpdate:
            return Alert(title: Text("Update Swatch This to play online"),
                         message: Text("To play online games, make sure everyone in the match has updated the app to the latest version in the App Store."),
                         dismissButton: .default(Text("Dismiss")))
            
        case .typeGameCenter:
            return Alert(title: Text("Couldn't connect to Game Center"),
                         message: Text("Make sure you have an internet connect and have signed into Game Center in the Settings app."),
                         dismissButton: .default(Text("Dismiss")))
            
            
        }
    }
    
    
    
    func isOtherPlayersTurn() {
        
        
        // keep track of if we're in OtherPlayersTurn. We'll only automatically push forward on a Game Center turn received if we're in it.
        // we set this to false when we leave OtherPlayersTurn
        
        self.viewRouter.inOtherPlayersTurn = true
        
    }
    
    
    
    // we need to be able to return a GameData object for the Pass & Play option
    func generateNewGameDataReturn(indiciesCount: Int, localRematch: Bool) -> GameData {
        
        
        self.generateNewGameData(indiciesCount: indiciesCount)
        
        return self.gameData
        
    }
    
    
    
    func generateNewGameData(indiciesCount: Int) {
        
        
        self.gameData.colorIndices = self.gameBrain.generateNIndices(count: indiciesCount)
        
    }
    
    
    
    
    
    func presentGame(_ notification: Notification) {
        
        // Ensure the object from the notification is a match object
        guard let match = notification.object as? GKTurnBasedMatch else {
            return
        }
        
        print("initial match.participants = \(match.participants.count)")

        // only send the player into the turn if we're in OtherPlayersTurn or Loading (and therefore the GameCenter match picker)
        if (self.viewRouter.currentPage == "game" &&
                self.viewRouter.onlineGame == true &&
                self.gameData.isComplete == false &&
                GameKitHelper.sharedInstance.canTakeTurnForCurrentMatch == false &&
                self.gameData.matchID == match.matchID) ||
            (self.viewRouter.currentPage == "otherTurn" && self.gameData.matchID == match.matchID) ||
            self.viewRouter.currentPage == "loading" {
            
            self.loadAndDisplay(loadedMatch: match)
            
        } else {
            
            //    self.matchForAlert = match
            self.alertId = AlertId(id: .typeTurn, match: match)
            
            
            // otherwise display an alert that it's their turn
            //   NotificationCenter.default.post(name: Notification.Name(rawValue: "yourTurnAlert"), object: match)
        }
        
        
    }
    
    
    func rematch(_ notification: Notification) {
        
        // Ensure the object from the notification is a match object
        guard let match = notification.object as? GKTurnBasedMatch else {
            return
        }
        
        self.loadAndDisplay(loadedMatch: match)
    }
    
    private func loadAndDisplay(loadedMatch: GKTurnBasedMatch) {
        
        print("initial loadedMatch.participants = \(loadedMatch.participants)")
        print("initial loadedMatch.ID = \(loadedMatch.matchID)")

        // Request the match data from Game Center to ensure we have the most up-to-date information
        loadedMatch.loadMatchData { data, error in
            
            let unpackedData: GameData
            
            if let data = data {
                
                
                do {
                    
                    // Construct a game model from the match data. GameData conforms to Codable
                    unpackedData = try JSONDecoder().decode(GameData.self, from: data)
                    
                    
                    /*
                     // I'm no longer checking app version for online match compatibility.
                     // The two things that would mess up online matches would be a change to the palatte indicies
                     // or gameData. To fix the first issue, there's the Palette Index column in Excel.
                     // To fix the second issue, if gameData gets changed later on, will require checking gameData vs what's needed and alerting the user if there's an issue
                     if self.checkAppVersions(unpackedData: unpackedData) == false {
                     
                     return  // abort loading match -- someone needs to update Swatch This from the App Store
                     
                     }
                     */
                    
                    
                    
                    if loadedMatch.status == .ended {
                        self.gameData.isComplete = true;
                    } else {
                        self.gameData.isComplete = false;
                    }
                    
                    
                    
                    // unpack the data and set our local GameData copy to match it
                    self.gameData.turnArray = unpackedData.turnArray
                    self.gameData.submittedColorNames = unpackedData.submittedColorNames
                    self.gameData.players = unpackedData.players
                    self.gameData.sortedPlayersArray = unpackedData.sortedPlayersArray
                    self.gameData.displayNames = unpackedData.displayNames
                    self.gameData.finalPointsArray = unpackedData.finalPointsArray
                    self.gameData.submissionsByPlayer = unpackedData.submissionsByPlayer
                    self.gameData.playersByRound = unpackedData.playersByRound
                    self.gameData.currentPlayer = unpackedData.currentPlayer
                    self.gameData.matchID = loadedMatch.matchID
                    self.gameData.onlineGame = true
                    
                    self.turnData.turnArray = unpackedData.turnArray
                    
                    
                    print("colors pt 1: \(self.gameData.colorIndices)")
                    
                    print("unpacked turnArray: \(self.turnData.turnArray)")
                    
                    
                    // if no rounds have been finished, then generate colors since it's a new game
                    if self.turnData.turnArray[1] == 0 {
                        
                        self.generateNewGameDataReturn(indiciesCount: 4, localRematch: false)
                        
                    } else {
                        
                        self.gameData.colorIndices = unpackedData.colorIndices
                    }
                    
                    
                    print("colors pt 2: \(self.gameData.colorIndices)")
                    
                    
                    
                    print("found online match data")
                    
                    self.viewRouter.playerCount = loadedMatch.participants.count
                    self.viewRouter.currentPage = "game"
                    self.viewRouter.onlineGame = true
                    
                    
                } catch {
                    print("catch: online match data")
                    
                    
                    if loadedMatch.isLocalPlayersTurn == false && loadedMatch.status != .ended {
                        
                        self.resetData()
                        
                        self.viewRouter.currentPage = "otherTurn"
                        
                        return  // abort loading match
                        
                    } else {
                        
                        // new game, we assume
                        
                        self.resetData()
                        self.viewRouter.playerCount = loadedMatch.participants.count
                        self.generateNewGameData(indiciesCount: 4)
                        self.viewRouter.currentPage = "game"
                        
                        print("new match set up, participants = \(self.viewRouter.playerCount)")
                        print("new match set up, ID = \(loadedMatch.matchID)")

                    }
                    
                }
            } else {
                print("else: online match data")
                // error, so just reset (is this the best choice?)
                self.resetData()
                self.viewRouter.playerCount = loadedMatch.participants.count
                self.gameData.colorIndices = self.gameBrain.generateNIndices(count: 4)
                self.viewRouter.currentPage = "game"
                
            }
            
            // Game Center: for managing the current match
            GameKitHelper.sharedInstance.currentMatch = loadedMatch
            
            // Present the game scene with the model from Game Center
            //    self.view?.presentScene(GameScene(model: model), transition: self.transition)
            
            
        }
    }
    
    
    func resetData() {
        
        self.turnData.turnArray = [0,0] // reset the turn array
        
        // reset GameData
        self.gameData.turnArray = [0, 0]
        // color indices are handled below
        self.gameData.submittedColorNames = [["Placeholder"], ["Placeholder"], ["Placeholder"], ["Placeholder"]]
        self.gameData.players = ["Player 1": 0, "Player 2": 0]
        self.gameData.sortedPlayersArray = ["Player 1", "Player 2"]
        self.gameData.displayNames = ["Player 1": "Player 1", "Player 2": "Player 2"]
        self.gameData.finalPointsArray = [1, 1]
        self.gameData.submissionsByPlayer = ["Submitted color" : "Player X"]
        self.gameData.playersByRound = [
            // round 0
            [
                ["Created": "Submitted color", "Guessed": "Guessed color" ],    // player 1
                ["Created": "Submitted color", "Guessed": "Guessed color" ],    // player 2
            ],
            
            // round 1
            [
                ["Created": "Submitted color", "Guessed": "Guessed color" ],
                ["Created": "Submitted color", "Guessed": "Guessed color" ]
            ],
            
            // round 2
            [
                ["Created": "Submitted color", "Guessed": "Guessed color" ],
                ["Created": "Submitted color", "Guessed": "Guessed color" ]
            ],
            
            // round 3
            [
                ["Created": "Submitted color", "Guessed": "Guessed color" ],
                ["Created": "Submitted color", "Guessed": "Guessed color" ]
            ]
        ]
        
        self.gameData.currentPlayer = 1
        self.gameData.colorIndices = [0, 0, 0, 0]
        self.gameData.isComplete = false
        self.gameData.matchID = "abc123"
        self.gameData.onlineGame = false
        
        self.viewRouter.colorIndices = [0,0,0,0]
        
        
    }
    
    
    func checkAppVersions(unpackedData: GameData) -> Bool {
        
        
        self.gameData.appVersion = unpackedData.appVersion
        
        
        // if one of the two version error conditions (match version > local or no local version) are met, then we abort
        if let appVersion = Float(UIApplication.appVersion!) {
            
            //  let roundedLocalVersion = Float(String(format: "%.2f", appVersion))!    // ALERT: this doesn't actually round
            //  let roundedMatchVersion = Float(String(format: "%.2f", self.gameData.appVersion))! // ALERT: this doesn't actually round
            
            if self.gameData.appVersion > appVersion {
                // the match is from a newer version of the app than the one we're currently running
                
                print("Update Swatch This to play online")
                
                errorAlertTitle = "Update Swatch This to play online"
                errorAlertMessage = "To play online games, update the app to the latest version in the App Store."
                
                self.alertId = AlertId(id: .typeUpdate, match: nil)
                
                self.viewRouter.currentPage = "menu"
                
                
                return false // will abort match loading
            }
            
        } else {
            // something funky is going on
            
            print("Could not determine local app version")
            
            errorAlertTitle = "Error"
            errorAlertMessage = "Could not determine local app version."
            
            self.alertId = AlertId(id: .typeUpdate, match: nil)
            
            self.viewRouter.currentPage = "menu"
            
            return false // will abort match loading
        }
        
        
        return true // we're good, load the match
        
    }
    
    
    func checkIfCurrentTurn(match: GKTurnBasedMatch) -> Bool {
        
        // true: we're good, load the match
        // false: not our turn, abort
        
        
        print("canTakeTurn: \(match.isLocalPlayersTurn)")
        
        return match.isLocalPlayersTurn
        
    }
    
    
    
    
    func resetGameData() -> GameData {
        
        self.resetData()
        
        return self.gameData
        
    }
    
    func resetTurnData() -> TurnData {
        
        self.turnData.turnArray = [0,0] // reset the turn array
        
        return self.turnData
        
    }
    
    
    func returnToMenu() {
        
        self.viewRouter.currentPage = "menu"
    }
    
    
}


extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

struct SwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        SwitcherView()
    }
}

