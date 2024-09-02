//
//  GameKitHelper.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/25/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

// https://www.raywenderlich.com/7544-game-center-for-ios-building-a-turn-based-game
// https://stackoverflow.com/questions/58722084/how-to-display-game-center-leaderboard-with-swiftui
// https://koenig-media.raywenderlich.com/downloads/iOS_Games_by_Tutorials_Bonus_Chapters_v_2_2.pdf


import Foundation
import GameKit
import SwiftUI

// helper class to make interacting with the Game Center easier

open class GameKitHelper: NSObject,  ObservableObject,  GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate  {
    public func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        
    }
    
    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        
    }
    
   
    
    typealias CompletionBlock = (Error?) -> Void
    typealias CompletionBlockRematch = (GKTurnBasedMatch?, Error?) -> Void

    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var currentMatchmakerVC: GKTurnBasedMatchmakerViewController?
    var currentMatchmakerVCTest: GKMatchmakerViewController?

    
    public var authenticationViewController: UIViewController?
    public var lastError: Error?
    
    enum GameKitHelperError: Error {
        case matchNotFound
    }
    
    
    
    private static let _singleton = GameKitHelper()
    public class var sharedInstance: GameKitHelper {
        return GameKitHelper._singleton
    }
    
    
    
    // CurrentMatch keeps track of the game the player is currently viewing
    // To determine if the player can take a turn, you use the current match and check if it’s the local player’s turn
    var currentMatch: GKTurnBasedMatch?
    var canTakeTurnForCurrentMatch: Bool {
        guard let match = currentMatch else {
            return true
        }
        
        return match.isLocalPlayersTurn
    }
    
    var currentMatchTest: GKMatch?

    
        
    override init() {
        super.init()
        
        /*
         if GKLocalPlayer.local.isAuthenticated {
         
         print("GKH init: GKLocalPlayer.local.isAuthenticated")
         GKLocalPlayer.local.register(self)
         } else {
         print("GKH init: GKLocalPlayer.local.isAuthenticated FALSE")
         
         }
         */
        
    }
    @Published public var enabled :Bool = false
    
    public var  gameCenterEnabled : Bool {
        return GKLocalPlayer.local.isAuthenticated }
    
    
    public func authenticateLocalPlayer() {
        
        GKLocalPlayer.local.authenticateHandler = {(viewController, error) in
            
            self.lastError = error as NSError?
            
            if viewController != nil {
                
                self.authenticationViewController = viewController
                
                PopupControllerMessage
                    .PresentAuthentication
                    .postNotification()
                
            }
                
            else {
                
                self.enabled = GKLocalPlayer.local.isAuthenticated
                
                print("GKH: self.enabled = \(self.enabled)")
                
                if self.enabled == true {
                    
                    self.registerPlayer()
                } else {
                    
                  
                }
                
            }
        }
    }
    
    
    
    public func registerPlayer() {
        
        if GKLocalPlayer.local.isAuthenticated == true {
            
            print("GKH registerPlayer: GKLocalPlayer.local.isAuthenticated")
            GKLocalPlayer.local.register(self)
            
 
            
        } else {
            print("GKH registerPlayer: GKLocalPlayer.local.isAuthenticated FALSE")
            
            self.authenticateLocalPlayer()
            
        }
        
    }
    
    public var gameCenterViewController : GKGameCenterViewController? { get {
        
        guard gameCenterEnabled else {
            print("Local player is not authenticated")
            return nil }
        
        let gameCenterViewController = GKGameCenterViewController()
        
        gameCenterViewController.gameCenterDelegate = self
        
//        gameCenterViewController.viewState = .achievements
        
        return gameCenterViewController
        }}
    
    
    public var gameCenterTurnBasedViewController : GKTurnBasedMatchmakerViewController? { get {
        
        //     ensure the player is authenticated
        guard gameCenterEnabled else {
            print("Local player is not authenticated")
            return nil }
        
                
        //   create a match request to send an invite using the matchmaker view controller
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 8
        request.defaultNumberOfPlayers = 3
        
        request.inviteMessage = "Want to play Swatch This?"
        
        
        // pass the request to the matchmaker view controller and present it
        let gameCenterTurnBasedViewController = GKTurnBasedMatchmakerViewController(matchRequest: request)
        
        
        if #available(iOS 15, *) {
            gameCenterTurnBasedViewController.matchmakingMode = GKMatchmakingMode.inviteOnly
        } else {
            // Fallback on earlier versions
        }
        
        /*
        let delayTime = DispatchTime.now() + .milliseconds(1000)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.matchmakerViewController = GKMatchmakerViewController(invite: invite)
                    self.matchmakerViewController!.matchmakerDelegate = self
                    self.delegate?.presentMatchmaking(viewController: self.matchmakerViewController!)
                }
        */
        
        gameCenterTurnBasedViewController.turnBasedMatchmakerDelegate = self
           
       
        
        currentMatchmakerVC = gameCenterTurnBasedViewController

                
      //  gameCenterTurnBasedViewController.viewState = .default
        
        return gameCenterTurnBasedViewController
        }}
    
    
    
    public var gameCenterViewControllerTest : GKMatchmakerViewController? { get {
        
        //     ensure the player is authenticated
        guard gameCenterEnabled else {
            print("Local player is not authenticated")
            return nil }
        
                
        //   create a match request to send an invite using the matchmaker view controller
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 8
        request.defaultNumberOfPlayers = 3
        
        request.inviteMessage = "Want to play Swatch This?"
        
        
        // pass the request to the matchmaker view controller and present it
        let gameCenterViewControllerTest = GKMatchmakerViewController(matchRequest: request)
        
        
        if #available(iOS 15, *) {
            gameCenterViewControllerTest?.matchmakingMode = GKMatchmakingMode.default
        } else {
            // Fallback on earlier versions
        }
        
        /*
        let delayTime = DispatchTime.now() + .milliseconds(1000)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.matchmakerViewController = GKMatchmakerViewController(invite: invite)
                    self.matchmakerViewController!.matchmakerDelegate = self
                    self.delegate?.presentMatchmaking(viewController: self.matchmakerViewController!)
                }
        */
        
        gameCenterViewControllerTest?.matchmakerDelegate = self
           
       
        
        currentMatchmakerVCTest = gameCenterViewControllerTest

                
      //  gameCenterTurnBasedViewController.viewState = .default
        
        return gameCenterViewControllerTest
        }}
    
    
    
    
    open func gameCenterViewControllerDidFinish(_
        gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(
            animated: true, completion: nil)
    }
    
    open func gameCenterTurnBasedViewControllerDidFinish(_
        gameCenterTurnBasedViewController: GKTurnBasedMatchmakerViewController) {
        
        gameCenterTurnBasedViewController.dismiss(
            animated: true, completion: nil)
    }
    
    
    
    func endTurn(_ model: GameData, completion: @escaping CompletionBlock) {
        
        
        // Ensure there’s a current match set
        guard let match = currentMatch else {
            completion(GameKitHelperError.matchNotFound)
            return
        }
        
        do {
            
            
         //   self.viewRouter.currentMatch = currentMatch?.matchID ?? "Error"
            
            model.matchID = match.matchID
            model.matchDate = Date()    // set match date to current date

            print(match.others)
                        
            
            // First check if any match.others.lastTurnDate are nil
            // If they are, that user hasn't taken a turn yet, so we'll send it to them
            // If none are nil, then we'll select the earliest lastTurnDate and send it to them
            
 
            let nextParticipant = self.findNextPlayer(otherPlayers: match.others)
            
           // this doesn't do anything
            let bootTimer: TimeInterval = 30
            
            // End the turn after serializing the updated game model and modifying the match. Being able to use Codable protocol to handle serialization vastly simplifies this logic
            match.endTurn(
         //       withNextParticipants: match.others, // need to fix this, I think -- need to go to next player
                withNextParticipants: nextParticipant,
                turnTimeout: bootTimer,  // boot timer
                match: try JSONEncoder().encode(model),
                completionHandler: completion
            )
        } catch {
            completion(error)
        }
    }
    
    
    
    func endGame(_ model: GameData, isTie: Bool, completion: @escaping CompletionBlock) {
        
        
        // Ensure there’s a current match set
        guard let match = currentMatch else {
            completion(GameKitHelperError.matchNotFound)
            return
        }
        
        do {
            
                
            var counter = 1
            
            for playerString in model.sortedPlayersArray {
                
                print("playerString: \(playerString)")

                // assign player number within context of our game, since participants are listed in the same order each time
                
                // what player number is this? -1 for the array index
                let playerIndex = Int(playerString.suffix(1))! - 1
                
                
                if isTie == false {
                    if counter == 1 {
                        match.participants[playerIndex].matchOutcome = .won
                    } else if counter == 2 {
                      //  match.participants[playerIndex].matchOutcome = .second
                        
                        match.participants[playerIndex].matchOutcome = .lost

                    }
                } else {
                    if counter == 1 {
                        match.participants[playerIndex].matchOutcome = .tied
                    } else if counter == 2 {
                        match.participants[playerIndex].matchOutcome = .tied
                    }
                }
                
                
                if counter > 2 {
                    
                    match.participants[playerIndex].matchOutcome = .lost

                }
                
                
                /* // this seems to set all non-winning players to #3
                if counter == 3 {
                    match.participants[playerIndex].matchOutcome = .third
                } else if counter == 4 {
                    match.participants[playerIndex].matchOutcome = .fourth
                } else if counter > 4 {
                    match.participants[playerIndex].matchOutcome = .lost
                }
                */
                
                counter += 1
                
            }
            
            
            
            
            // End the turn after serializing the updated game model and modifying the match. Being able to use Codable protocol to handle serialization vastly simplifies this logic
            match.endMatchInTurn(
                withMatch: try JSONEncoder().encode(model),
                completionHandler: completion
            )
        } catch {
            completion(error)
        }
    }
    
    
    
    
    
    
    func findNextPlayer(otherPlayers: [GKTurnBasedParticipant]) -> [GKTurnBasedParticipant] {
        
        for player in otherPlayers {
            
            if player.lastTurnDate != nil {
                // have taken turn
                print("have taken turn")

            } else {
                // have not taken turn, send to them
                print("have not taken turn")

                return [player]
            }
        }
        
        
        // if we've gotten this far, none of the lastTurnDates were nil
        if let earliest = otherPlayers.min(by: { $0.lastTurnDate! < $1.lastTurnDate! }) {
            // use earliest taken turn
            
            print(earliest)
            
            return [earliest]
            
            
        }
        
        
        // last resort: just return the other players array
        return otherPlayers
        
    }
    
    
    
   
    
    func winner(gameData: GameData, onlineGame: Bool) -> String {
        
        if onlineGame == false {
            
            return "\(gameData.sortedPlayersArray[0]) is the master colorsmith!"
            
        } else {
            
            
            guard let match = currentMatch else {
                //  completion(GameKitHelperError.matchNotFound)
                return "Good game!"
            }
            
            
            print("match.currentParticipant?.matchOutcome: \(String(describing: match.currentParticipant?.matchOutcome))")
            
            
            // match.currentParticipant?.player?.playerID == GKLocalPlayer.localPlayer().playerID
            if match.currentParticipant?.matchOutcome == .won { // ALERT: no current participant in completed match
                return "You are the master colorsmith!"
            } else {
                
                for playerString in gameData.sortedPlayersArray {
                    
                    let playerNum = Int(playerString.suffix(1))! - 1
                    
                    if match.participants[playerNum].matchOutcome == .won {
                        return "\(playerString) is the master colorsmith!"
                    }
                }
                
                // if we've gotten this far there's an error
                return "Good game!"
                
            }
        }
        
    }

    
    
    func submitScoreToLeaderboard(points: Int) {
        
        // if player is logged in to GC, then report the score
        if GKLocalPlayer.local.isAuthenticated {
            
            let player = GKLocalPlayer.local
                        
            GKLeaderboard.submitScore(points, context: 0, player: player, leaderboardIDs: ["swatchthis.leaderboard.high_score"]) { error in
                
                print("Error submitting score to leaderboard: \(String(describing: error))")
                
            }
        } else {
            
            print("Error submitting score to leaderboard: wasn't logged in to GC")

        }
    }
    
    
    func reportAchievement(identifier: String, percentComplete: Double) {
        
        print("reporting achievement: \(identifier) at \(percentComplete)%")
        
        let achievement = GKAchievement(identifier: identifier)
        
        achievement.percentComplete = percentComplete
        
        achievement.showsCompletionBanner = true
        
        GKAchievement.report([achievement]) { error in
            if let error = error {
                print("Error in reporting achievements: \(error)")
            }
        }
    }
    
    
    
    func getLocalUserName() -> String {
        
        return GKLocalPlayer.local.alias
        
    }
    
    
    
    // for replacing the sorted player array with Game Center player names
    func getPlayerUserNames(displayNames: [String : String], sortedPlayersArray: [String]) -> [String : String] {
        
        guard let match = currentMatch else {
            //  completion(GameKitHelperError.matchNotFound)
            return ["Error" : "Error"]
        }
        
        var updatedDisplayNames = displayNames
        
        
        for player in sortedPlayersArray {  // iterate through the rest of the players
            
            let playerNum = Int(player.suffix(1))! - 1
            let playerUserName = match.participants[playerNum].player?.alias
            
            var updateString = ""
            
            if let unwrappedName = playerUserName {
                updateString = unwrappedName
            } else {
                updateString = "Player \(playerNum)"
            }
            
            updatedDisplayNames.updateValue(updateString, forKey: player)
        }
        
        
        return updatedDisplayNames
        
    }
 
    
    /*
     // https://stackoverflow.com/questions/39690387/game-center-player-photos-in-ios-10
     // https://stackoverflow.com/questions/48523154/swift-how-to-return-from-a-within-a-completion-handler-closure-of-a-system-fun
    // for retrieving the Game Center avatar for a specific player
    func getPlayerAvatar(playerAlias: String) -> UIImage? {
        
        guard let match = currentMatch else {
            return UIImage(imageLiteralResourceName: "AppIcon")
        }
            
        
        for participant in match.participants {  // iterate through the players until we find the one we want
            
            let playerUserName = participant.player?.alias
            
            if playerUserName == playerAlias {
                                
                participant.player?.loadPhoto(for: .small, withCompletionHandler: {(photo: UIImage?, error: Error?) -> Void in
                                            if !(error != nil) {
                                                
                                                return photo

                                            }
                                            else {
                                                print("Error loading image")
                                                return UIImage(imageLiteralResourceName: "AppIcon")
                                            }
                                        })
            }
                       
        }
        

    }
    
    */
    
    
    // for determining who's turn it is in Other Player's Turn
    func getCurrentPlayer() -> String {
                    
            guard let match = currentMatch else {
                //  completion(GameKitHelperError.matchNotFound)
                return "them"   // if there's an error, default to "them", so we get "Waiting on them"
            }
                
        return match.currentParticipant?.player?.alias ?? "them"

    }
    
    
    
    func rematch(completion: @escaping CompletionBlock) {
        
        
        // Ensure there’s a current match set
        guard let match = currentMatch else {
            completion(GameKitHelperError.matchNotFound)
            return
        }
        
        do {
            
            match.rematch { (newMatch: GKTurnBasedMatch?, rematchError: Error?) in
                
                if rematchError != nil {
                    
                    completion(rematchError)
                    return
                    
                }
                
                NotificationCenter.default.post(name: .rematchNotification, object: newMatch)
                
            }
        }
        
    }
}


extension GameKitHelper: GKTurnBasedMatchmakerViewControllerDelegate {
    
    public func turnBasedMatchmakerViewControllerWasCancelled(
        _ viewController: GKTurnBasedMatchmakerViewController) {
        
        
        viewController.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: .returnToMenu, object: nil)
        })
    }
    
    public func turnBasedMatchmakerViewController(
        _ viewController: GKTurnBasedMatchmakerViewController,
        didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
}

extension GameKitHelper: GKLocalPlayerListener {
    
    public func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        // if a player quits, you need to let the other active players know
        let activeOthers = match.others.filter { other in
            return other.status == .active
        }
        
        // set the quitting player’s outcome to lost and each other active player’s outcome to win
        // should probably just remove that person in case it's a big game (>2 players)
        // but for now this is fine
        match.currentParticipant?.matchOutcome = .lost
        activeOthers.forEach { participant in
            participant.matchOutcome = .won
        }
        
        // end the match with the updated data
        match.endMatchInTurn(
            withMatch: match.matchData ?? Data()
        )
    }
    
    public func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        
        if let vc = currentMatchmakerVC {
            currentMatchmakerVC = nil
            vc.dismiss(animated: true)
            
        }
        
        
        // issue is that didBecomeActive sometimes returns false when we want true. Specifically, for color guessing turn when local player is taking last turn of the game. It seems like we can check if the local player is the current player, though. Does this always return true?
        
        print("\(GKLocalPlayer.local.teamPlayerID)")
        print("\(String(describing: match.currentParticipant?.player?.teamPlayerID))")
        
        // When the app receives a turn event, the event includes a Bool which indicates if the turn should present the game. You use one of the notifications you defined earlier to notify the menu scene.
        
        if didBecomeActive == false && GKLocalPlayer.local.teamPlayerID == match.currentParticipant?.player?.teamPlayerID {
            //  self.player(localPlayer, receivedTurnEventFor: match!, didBecomeActive: false)
            
            
            print("local player is current player, didBecomeActive: false")
            
          //  NotificationCenter.default.post(name: .yourTurnAlert, object: match)
            NotificationCenter.default.post(name: .presentGame, object: match)

            
        } else if didBecomeActive == true {
            
            print("local player is current player, didBecomeActive: true")

           NotificationCenter.default.post(name: .presentGame, object: match)
            
        } else {
            
            return
            
        }
        
        
        
        
    }
    
    
    public func player(_ player: GKPlayer, matchEnded: GKTurnBasedMatch) {
        
        
        print("match ended")
        NotificationCenter.default.post(name: .presentGame, object: matchEnded)

        
    }

    
    
    
    
}

extension Notification.Name {
    static let presentGame = Notification.Name(rawValue: "presentGame")
    static let rematchNotification = Notification.Name(rawValue: "rematchNotification")
    static let returnToMenu = Notification.Name(rawValue: "returnToMenu")
    static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
    
}

