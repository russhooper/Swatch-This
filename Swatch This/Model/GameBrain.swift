//
//  GameBrain.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/11/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import Foundation
import AudioToolbox
import StoreKit

struct GameBrain {
    
    let palette = Palette()
        
    
    
    func generateNIndices(count: Int) -> [Int] {
        
        // we get an array of available indicies. Then we can randomly pull from that
        let availablePalette = getAvailablePalette(excludeRecentColors: true)
        
        
        // set up returnArray of indices with first, random element
        var returnArray = [
            availablePalette.randomElement()!
        ]
        
        // set up array of groups for the selected colors with the first element's color group
        var groupArray = [
            self.getColorGroup(index: returnArray[0])
        ]
        
        
        for _ in 1...count-1 {
            
            // get a random index from the available palette
            var randomInt = availablePalette.randomElement()!
            
            // check if it's unique by index and color group
            while returnArray.contains(randomInt) || groupArray.contains(self.getColorGroup(index: randomInt)) {
                
                // need to generate a new random index from the available palette
                randomInt = availablePalette.randomElement()!
            }
            
            // index must now be unique -- add it to the return array
            returnArray.append(randomInt)
            groupArray.append(self.getColorGroup(index: randomInt))

        }
        
        
        // store the swatches used in the history so we don't pick a repeat next time
       
        // access Shared Defaults Object
        let userDefaults = UserDefaults.standard
        userDefaults.set(returnArray, forKey: "swatchthis.swatchHistory")

      //  returnArray = [141, 56, 154, 188] //  for screenshots
     //   returnArray = [93, 85, 153, 13]  //  for screenshots
    //    returnArray = [17, 158, 32, 149]
    //    returnArray = [149, 32, 158, 17] // I used this

   //     returnArray = [68, 181, 153]  //  for screenshots. I used this
    //    returnArray = [18, 181, 153]  //  for screenshots
    //         returnArray = [132, 181, 153]  //  for screenshots
        // returnArray = [13, 181, 153]  //  for screenshots.


        return returnArray
    }
    
    
    
    
    
    func getAvailablePalette(excludeRecentColors: Bool) -> [Int] {
        
        let palettePackUnlocked = UserDefaults.standard.bool(forKey: "swatchthis.IAP.palettepack1")

        let enableBaseGame = UserDefaults.standard.bool(forKey: "swatchthis.basegame.enabled")
        let enablePalettePack = UserDefaults.standard.bool(forKey: "swatchthis.palettepack1.enabled")
        
                
        
        var enabled = [Int]()
        
        if enableBaseGame == true {
            
            enabled.append(0) // 0 is the base game's code
        }
        
        if palettePackUnlocked == true && enablePalettePack == true {
            
            enabled.append(1)  // 1 is the Palette Pack's code
        }
        
        // now check to make sure it's not an empty array
        if enabled.isEmpty == true {
            // if it's empty, put the base game in as a default
            enabled.append(0)

        }

        
        var availablePalette = [Int]()
        
        for index in 0...palette.masterPalette.count-1 {
            
            for pack in enabled {
               
                if palette.masterPalette[index].pack == pack {
                    
                    availablePalette.append(index)
                }
            }
        }
        
        
        if excludeRecentColors == true {
            
            // now we need to remove any swatches used in the last game
            
            // access Shared Defaults Object
            let userDefaults = UserDefaults.standard
            
            let swatchHistoryArray = userDefaults.object(forKey: "swatchthis.swatchHistory") as? [Int]
            
            if swatchHistoryArray?.count ?? 0 > 3 { // if problem with stored history, defaults to a count of 0
             
                // let swatchHistorySet = Set(swatchHistoryArray)
                 let filteredAvailablePalette = availablePalette.filter { !swatchHistoryArray!.contains($0) }
                 
                 return filteredAvailablePalette
                
            } else {    // if no history, we'll return the full array
                
                return availablePalette

            }
        } else {
            
            // return the full array
            return availablePalette
            
        }
        
    }
    
    
    
    func considerShowingReviewPrompt() {
        
        var gamesFinishedCount = UserDefaults.standard.integer(forKey: "swatchthis.gamesFinishedCount")
        
        gamesFinishedCount = gamesFinishedCount + 1
   
        
        if gamesFinishedCount == 2 {
            // we'll only bug the user for this after their second game end (note that there's no real way to know if Pen & Paper was actually played or just visited)
            
            // show Swatch This App Store rating prompt
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
            
        }
        
        // store the int
        UserDefaults.standard.set(gamesFinishedCount, forKey: "swatchthis.gamesFinishedCount")
        
    }
    
    
    // for the in-game swatch stacks. Only need 3 since the top will always have no rotation
    func generate3Angles() -> [Double] {
        
        // set up returnArray of angles for swatch rotations
        let returnArray = [
            Double.random(in: -10 ..< 10),
            Double.random(in: -10 ..< 10),
            Double.random(in: -10 ..< 10)
        ]
        
        return returnArray
    }
    
    // for the Other Player's Turn swatch stacks
    func generate4Angles() -> [Double] {
        
        // set up returnArray of angles for swatch rotations
        let returnArray = [
            Double.random(in: -10 ..< 10),
            Double.random(in: -10 ..< 10),
            Double.random(in: -10 ..< 10),
            Double.random(in: -10 ..< 10)
        ]
        
        return returnArray
    }
    
    func generate4Offsets() -> [Float] {
        
        // set up returnArray of offsets for swatch stack. This can be used for X or Y.
        let returnArray = [
            Float.random(in: -15 ..< 15),
            Float.random(in: -15 ..< 15),
            Float.random(in: -15 ..< 15)
        ]
        
        return returnArray
    }
    
    
    func playSlideSoundEffect() {

        playSoundEffect(title: "Card Flip", soundID: 0)

    }
    
    func playDealSoundEffect() {
       
        playSoundEffect(title: "Card Deal", soundID: 1)

    }
    
    func playCorrectSoundEffect() {
        
        playSoundEffect(title: "Correct Guess", soundID: 2)

    }
    
    func playWinSoundEffect() {
    
        playSoundEffect(title: "Master Colorsmith", soundID: 3)
        
    }
    
    func playSoundEffect(title: String, soundID: UInt32) {
       
        if let soundURL = Bundle.main.url(forResource: title, withExtension: "mp3") {
            var mySound: SystemSoundID = soundID
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            
            // play
            AudioServicesPlaySystemSound(mySound);
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // call after 2 seconds to give the sound time to play
                AudioServicesDisposeSystemSoundID(mySound)  // clean up the memory
                
            }
        }
    }
    
    func getColorGroup(index: Int) -> String {
                
        let colorGroup = palette.masterPalette[index].group
        
        return colorGroup
    }
    
    
    
    
    mutating func setupPlayers(playerCount: Int) -> [String: Int] {
        
        // starter array already has Player 1 and Player 2
        var i = 3
        
        // array of dictionaries of player, score
        var updatedPlayersArray = [
            "Player 1": 0,
            "Player 2": 0
        ]   // will have at least 2 players
        
        while  updatedPlayersArray.count < playerCount {
            
            updatedPlayersArray["Player \(i)"] = 0
            i += 1
        }
        
        print("players: \(updatedPlayersArray)")
        
        return updatedPlayersArray
    }
    
    
    mutating func setupPlayersByRound(playerCount: Int) -> [[[String: String]]] {
        
        
        
        // array of dictionaries of player, score
        var updatedPlayersByRound = [
            
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
        ]   // will have at least 2 players
        
        
        // starter array already has Player 1 and Player 2
        
        let appendDict = ["Created": "Submitted color", "Guessed": "Guessed color" ]
        
        for round in 0...3 {  // four rounds
            
            
            print("updatedPlayersByRound[\(round)].count = \(updatedPlayersByRound[round].count)")
            
            while  updatedPlayersByRound[round].count < playerCount {
                
                // playersByRound[what turn are we on?][what player is this? (considering arrays start at 0)][get "Created" key] = set to template dictionary
                
                updatedPlayersByRound[round].append(appendDict)
                                
                print("playersByRound (\(round)): \(updatedPlayersByRound)")

                
            }
            
            print("playersByRound (\(round)): \(updatedPlayersByRound)")

        }
        
        print("final playersByRound: \(updatedPlayersByRound)")
        
        return updatedPlayersByRound
    }
    
    
    
   
    
    mutating func advanceGame(turnArray: [Int], indexArray: [Int], playerCount: Int) -> [Int] {
        
        print("advanceGame: \(turnArray)")
        
        var turn = turnArray[0]
        var roundsFinished = turnArray[1]
        
        if turn >= 3 {  // we're at the end of a player's 4 submissions
            
            
            if  roundsFinished+1 >= playerCount {    // End of game -- display score screen and button back to menu
            }
            
            // we need to have the submitted colors list with the real color of the previous round in it - this should have been made with the first player's submissions
            turn = 0    // reset turns taken counter
            roundsFinished += 1
            
        } else {
            // only advance self.turnsTaken if:
            // we're not at the end of the player's 4 turns or
            // advancing the game will not put us in the round end state
            
            turn += 1
            
        }
        
        print("Turn: \(turn), rounds finished: \(roundsFinished)")
        
        
        return [turn, roundsFinished]
        
        
    }
    
    
    func updateUserName(round: Int, userName: String, displayNames: [String: String]) -> [String: String] {
        
        var updatedDisplayNames = displayNames
        
        // since this is the first round, (turn+1) must mean Player X
        updatedDisplayNames["Player \(round+1)"] = userName
        
        return updatedDisplayNames
        
    }
    
    
    func isPlayerEnd(turnArray: [Int]) -> Bool {
        
        let turnsTaken = turnArray[0]
        let roundsFinished = turnArray[1]
        
        let returnBool = turnsTaken >= 4 || (turnsTaken == 0 && roundsFinished > 0) // we're at the end of a player's submissions (4 total submissions, and this is after turnsTaken has been incremented)
        
        print("isPlayerEnd: \(returnBool)")
        
        return returnBool
    }
    
    
    func isSubmissionEnd(roundsFinished: Int, playerCount: Int) -> Bool {
        
        print("roundsFinished: \(roundsFinished), playerCount: \(playerCount)")
        
        
        let returnBool = roundsFinished >= playerCount
        print("isSubmissionEnd: \(returnBool)")
        
        return returnBool
        
    }
    
    
    // the names are now alphabetized within GuessColorsView's List using .sorted()
    // for some reason this would sometimes not get called or work -- seems like after a few rematches
    func alphabetizeSubmittedColors(gameData: GameData) -> GameData {
                
        let sortedGameData = gameData
        
        for round in (0...3) {
            
            sortedGameData.submittedColorNames[round] = gameData.submittedColorNames[round].sorted()
                    
        }
        
        return sortedGameData
        
    }
    
    
    func getColorHex(turn: Int, indexArray: [Int]) -> UInt32 {
        
        var paletteColorIndex = 0
        
        if indexArray.count > turn {    // safety check
            paletteColorIndex = indexArray[turn]
        }
        
        
        
        //    print("getColorHex: paletteColorIndex: \(paletteColorIndex)")
        
        return palette.masterPalette[paletteColorIndex].hex
    }
    
    func getColorHexForScoreDetail(turn: Int, indexArray: [Int]) -> UInt32 {
        
        var paletteColorIndex = 0
        
        if indexArray.count > turn {    // safety check
            paletteColorIndex = indexArray[turn]
        }
        
        
        let colorHex = palette.masterPalette[paletteColorIndex].hex
        
        // determine if the color is too light to show over the white background
        
        /*
        var c = colorHex.removeFirst();      // strip #
        var rgb = parseInt(c, 16);   // convert rrggbb to decimal
        var r = (rgb >> 16) & 0xff;  // extract red
        var g = (rgb >>  8) & 0xff;  // extract green
        var b = (rgb >>  0) & 0xff;  // extract blue

        var luma = 0.2126 * r + 0.7152 * g + 0.0722 * b; // per ITU-R BT.709

        if (luma < 40) {
            // pick a different colour
        }
        
        */
        
        /*
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1_000
        
        if brightness >= 0.5 {
            
            // use dark
        } else {
            
            // use light
        }
        */
        
        /*
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
*/
       // hexStringToUIColor(hex: String(colorHex)
                           
     //   UIColor(hex: colorHex).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        
        
        
        //    print("getColorHex: paletteColorIndex: \(paletteColorIndex)")
        
        return colorHex
    }
    
    /*
    func UIColorFromHex(hex: UInt32, opacity:Double = 1.0) {
        
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
       // self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
        
        
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    */
    
    func getColorHexOfFullPalette(index: Int) -> UInt32 {
                        
        return palette.masterPalette[index].hex
        
    }
    
    
    func getColorName(turn: Int, indexArray: [Int]) -> String {
        
        var paletteColorIndex = 0
        
        if indexArray.count > turn {    // safety check
            paletteColorIndex = indexArray[turn]
        }
        
        let colorName = palette.masterPalette[paletteColorIndex].name
        
     //   print("getColorName: \(colorName)")
        
        return colorName
    }
    
    
    func getColorCompany(turn: Int, indexArray: [Int]) -> String {
        
        var paletteColorIndex = 0
        
        if indexArray.count > turn {    // safety check
            paletteColorIndex = indexArray[turn]
        }
        
        let companyName = palette.masterPalette[paletteColorIndex].company
        
     //   print("getColorCompany: \(companyName)")
        
        return companyName
    }
    
    
    func getColorURL(turn: Int, indexArray: [Int]) -> String {
        
        var paletteColorIndex = 0
        
        if indexArray.count > turn {    // safety check
            paletteColorIndex = indexArray[turn]
        }
        
        let colorWebsite = palette.masterPalette[paletteColorIndex].website
        
     //   print("getColorURL: \(colorWebsite)")
        
        return colorWebsite
    }
        
    
    
    func storeUserColorName(turnArray: [Int], userColor: String, indexArray: [Int], submittedColors: [[String]]) -> [[String]] {
        
        print("submittedColorNames 1: \(submittedColors)")
        print("userColor: \(userColor)")
        
        var updatedColorNames = submittedColors
        
        let turn = turnArray[0]
        let roundsFinished = turnArray[1]
        
        
        if  roundsFinished == 0 {    // first submissions of the game
            updatedColorNames[turn] = [    //  overwrite the submitted color names array for this round to have the actual name
                self.getColorName(turn: turn, indexArray: indexArray)
            ]
        }
        
        
        // append submitted array for this round with submitted name
        updatedColorNames[turn].append(userColor)
        
        
        
        print("submittedColorNames 2: \(updatedColorNames)")
        
        return updatedColorNames
        
    }
    
    
    func checkAnswer(turn: Int, colorGuessed: String, colorIndices: [Int]) -> Bool {
        
        let actualName = self.getColorName(turn: turn, indexArray: colorIndices)
        
        if colorGuessed == actualName {
            return true
        } else {
            return false
        }
        
    }
    
    
    func shouldShowUsernameEntry(turnData: [Int], displayNames: [String: String], onlineGame: Bool, showUsernameToggle: Bool) -> Bool {

        let turn = turnData[0]
        let round = turnData[1]
        
        let playerString = "Player \(round+1)"
        
        var hasNewDisplayName = true    // assume a new name has been entered; will check below
        
        if displayNames[playerString] == playerString ||    // if the displayname is the default Player X...
            displayNames[playerString] == nil { // or no displayName exists in this slot
                
            // then we'll say that no name has been created
            hasNewDisplayName = false
        }
        
        if onlineGame == false &&
            showUsernameToggle == true &&
            turn == 0 &&
            hasNewDisplayName == false {
            
            return true
        } else {
            
            return false
        }
        
    }
    
    
    func isPlayersOwnColor(playersByRound: [[[String:String]]], turn: Int, currentPlayer: Int, colorName: String) -> Bool {
        
        // turn is actually round here, since for each turn taken by each player they're viewing a round's worth of submissions
        let created = playersByRound[turn][currentPlayer-1]["Created"]!
        
        if created == colorName {
            
            return true
        } else {
            return false
        }
        
    }
    
    
    
    func endOnlineTurn(gameData: GameData) {
        
        if GameKitHelper.sharedInstance.canTakeTurnForCurrentMatch == true {
            
            GameKitHelper.sharedInstance.endTurn(gameData) { error in
                defer {
                    //   self.isSendingTurn = false
                }
                
                if let e = error {
                    print("Error ending turn: \(e.localizedDescription)")
                    return
                }
            }
        } else {
            print("Error ending turn: canTakeTurnForCurrentMatch == false")

        }
    }
    
    func endOnlineGame(gameData: GameData) {
        
        var isTie = false
        
        gameData.onlineGame = true  //  for History; otherwise defaults to false
        
        if GameKitHelper.sharedInstance.canTakeTurnForCurrentMatch == true {
            
            
            // upload
            
            if gameData.finalPointsArray[0] == gameData.finalPointsArray[1] {
                isTie = true
            }
            
            
            GameKitHelper.sharedInstance.endGame(gameData, isTie: isTie) { error in
                defer {
                    //   self.isSendingTurn = false
                }
                
                if let e = error {
                    print("Error ending match: \(e.localizedDescription)")
                    return
                }
            }
        }
    }
    
    
    
    func saveMatchToHistory(gameData: GameData) {
       
        if gameData.onlineGame == false {   // we don't save the win/loss history for local games
            
            return
        }
        
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        struct History: Codable {
            var gameDataArray: [String: GameData]
        }
        
        
        let matchID = gameData.matchID
        
        let retrievedHistory = retrieveMatchHistory()
        
        if retrievedHistory == nil {
            let newGameDataArray:[String: GameData] = [matchID:gameData]
                        
            // save the new history
             if let encoded = try? encoder.encode(History(gameDataArray: newGameDataArray)) {
                 defaults.set(encoded, forKey: "MatchHistory")
                 print("saved match as new history")
             }
            
            // no saved data at all, we need to do that and update achievements
            
        } else if checkIfMatchInHistory(loadedHistory: retrievedHistory!, matchID: matchID) != true {
            
                        
            // check if the match is already in the history. If not, then the achievements will need to be updated.

            
            // load the existing history of GameDatas
            if var loadedGameDataArray = retrievedHistory {
                
                loadedGameDataArray[matchID] = gameData
                
                // save the new full history
                 if let encoded = try? encoder.encode(History(gameDataArray: loadedGameDataArray)) {
                     defaults.set(encoded, forKey: "MatchHistory")
                     print("appended match")
                 }

            } else {
                
                print("error loading history")

                
                return  // abort
            }
            
            
        } else {
            
            // abort: don't need to update history/achievements since they're already in there
            
            return
            
        }
        
        
        let localPlayerDisplayName = GameKitHelper.sharedInstance.getLocalUserName()

        let localPlayer = getLocalPlayerNum(localPlayerDisplayName: localPlayerDisplayName, gameData: gameData)
        
        
        saveWonToHistory(gameData: gameData, wonHistory: retrieveWonHistory(), localPlayer: localPlayer, localDisplayName: localPlayerDisplayName)
        
        
        let newFooled = calculateFooledCount(localPlayer: localPlayer, playersByRound: gameData.playersByRound, playerCount: gameData.players.count)
        saveFooledToHistory(newFooled: newFooled, fooledHistory: retrieveFooledHistory())
                
        
        // if there's a problem, default to 0 new points
        savePointsToHistory(newPoints: gameData.players[localPlayer] ?? 0, 
                            numberOfPlayers: gameData.finalPointsArray.count)
        
        
        // High Score Leaderboard; Prismania, Lifetime Points, and Goose Egg achievements are uploaded in savePointsToHistory
        
        // Chroma Con, Besties, and Soul Mates achievements are uploaded in calculatedFooledCount
        
    }
    
    
    func getLocalPlayerNum(localPlayerDisplayName: String, gameData: GameData) -> String {
        
        print("GKLocalPlayer name: \(localPlayerDisplayName)")
        
        // determine local player's Player #

        var localPlayer = "Player 1" // placeholder
        if let key = gameData.displayNames.first(where: { $0.value == localPlayerDisplayName })?.key {
           
            localPlayer = key
            
            print("Player #: \(localPlayer)")

            
        } else {
            
            print("Error finding player # from display name")
        }
        
        return localPlayer
        
    }
    
    
    
    func retrieveMatchHistory() -> [String: GameData]? {
        
        
        struct History: Codable {
            var gameDataArray: [String: GameData]
        }
        
        
        let defaults = UserDefaults.standard

        if let matchHistory = defaults.object(forKey: "MatchHistory") as? Data {
            
            
            let decoder = JSONDecoder()
            if let loadedHistory = try? decoder.decode(History.self, from: matchHistory) {
                print("success loading history: \(loadedHistory.gameDataArray.count) matches")

                return loadedHistory.gameDataArray
            } else {
                return nil  // error
            }
        } else {
            return nil  // no match history
        }
                
        
        
    }
    
    
    func checkIfMatchInHistory(loadedHistory: [String: GameData], matchID: String) -> Bool {
        
        if loadedHistory.count > 0 {
                        
            if loadedHistory[matchID] != nil {
                return true
            } else {
                return false    // doing it like this in case this is a multithreaded operation
            }
        } else {
            
            return false    // error
        }
    }
    
    
    
    
    
    func retrievePointHistory() -> Int {
        
        
        let defaults = UserDefaults.standard
        
        struct PointsHistory: Codable {
            var points: Int
        }

        if let points = defaults.object(forKey: "PointHistory") as? Data {
            let decoder = JSONDecoder()
            if let loadedPoints = try? decoder.decode(PointsHistory.self, from: points) {
                print("success loading points: \(loadedPoints.points)")
                
                return loadedPoints.points
            } else {
                return 0    // doing it like this in case this is a multithreaded operation
            }
        } else {
            return 0
        }
        
    }
    
    
    func savePointsToHistory(newPoints: Int, numberOfPlayers: Int) {
        
            
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        
        struct PointsHistory: Codable {
            var points: Int
        }
        
        var lifetimePoints: Int = 0
        
        lifetimePoints = retrievePointHistory() + newPoints
        
        // save the new history
        if let encoded = try? encoder.encode(PointsHistory(points: lifetimePoints)) {
            defaults.set(encoded, forKey: "PointHistory")
            print("saved points: \(lifetimePoints)")
        }
        
        if newPoints > 0 {
            
            // submit the score to the High Score leaderboard. I assume lower scores don't overwrite higher ones?
            GameKitHelper.sharedInstance.submitScoreToLeaderboard(points: newPoints)
            
            
            // Lifetime points achievements
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.5000_points", percentComplete: 100 * Double(lifetimePoints)/Double(5000))
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.3000_points", percentComplete: 100 * Double(lifetimePoints)/Double(3000))
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.2000_points", percentComplete: 100 * Double(lifetimePoints)/Double(2000))
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.1000_points", percentComplete: 100 * Double(lifetimePoints)/Double(1000))
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.500_points", percentComplete: 100 * Double(lifetimePoints)/Double(500))
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.100_points", percentComplete: 100 * Double(lifetimePoints)/Double(100))
            
            
            // Prismania achievement
            if newPoints == calculateMaxPoints(numberOfPlayers: numberOfPlayers) {
                GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.prismania", percentComplete: Double(100))

            }
            
            
            
        } else {
            
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.goose_egg", percentComplete: Double(100))
            
        }
        
        
    }
    
    
    func calculateMaxPoints(numberOfPlayers: Int) -> Int {
        
        // achieve max points if:
        // correct guess in 4 rounds = 4 * (10 * # of players) points
        // fooled 4 * numberOfPlayers = 4 * (15 * # of players) points
        
        
        let maxPoints = 4*(calculateCorrectGuessPoints(numberOfPlayers: numberOfPlayers)) + 4*15*numberOfPlayers
        
        print("max points: \(maxPoints)")
        
        return maxPoints
        
    }
    
    
    func calculateCorrectGuessPoints(numberOfPlayers: Int) -> Int {
        
        // this is the only place in the app this formula is calculated
        let points = 5+5*numberOfPlayers
        
        
        return points
    }
    
    
    func retrieveFooledHistory() -> Int {
        
        
        let defaults = UserDefaults.standard
        
        struct FooledHistory: Codable {
            var fooled: Int
        }

        if let fooled = defaults.object(forKey: "FooledHistory") as? Data {
            let decoder = JSONDecoder()
            if let loadedFooled = try? decoder.decode(FooledHistory.self, from: fooled) {
                print("success loading fooled: \(loadedFooled.fooled)")

                return loadedFooled.fooled
            } else {
                return 0    // doing it like this in case this is a multithreaded operation
            }
        } else {
            return 0
        }
                        
    }
    
    
    
    func calculateFooledCount(localPlayer: String, playersByRound: [[[String: String]]], playerCount: Int) -> Int {
        
        var turn = 0
        var fooledTally = 0
        var newFooledArray: [String] = []
        var soulMatesArray: [String] = []
        var bestiesBool = false
        
        for round in (0...3) {
            
            turn = 0
            
            // playersByRound[round][what player is this?][get "Created" key]
            let created = playersByRound[round][getPlayerInt(playerString: localPlayer) - 1]["Created"]!

            // if the player's created color was guessed by any other players, we'll add that to the count
            for data in playersByRound[round] {
                
                if created == data["Guessed"] {
                   
                    fooledTally = fooledTally + 1
                    
                    let fooledPlayer = "Player \(turn+1)"
                    
                    
                    if newFooledArray.count > 0 {
                        newFooledArray.append(fooledPlayer)
                    } else {
                        newFooledArray = [fooledPlayer]
                    }
                    
                    
                    // find out what color that player created
                    let theyCreated = playersByRound[round][turn]["Created"]!
                    
                    // see if the local player picked that color
                    let localGuessed = playersByRound[round][getPlayerInt(playerString: localPlayer) - 1]["Guessed"]!
                    
                    if localGuessed == theyCreated {
                        
                        bestiesBool = true
                        
                        if soulMatesArray.count > 0 {
                            soulMatesArray.append(fooledPlayer)
                        } else {
                            soulMatesArray = [fooledPlayer]
                        }
                    }

                    
                }
                
                turn = turn + 1
            }
                        
            
        }
        
        
        if bestiesBool == true && playerCount > 2 {    // players have picked the same color and there are 3+ total players
            
            GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.besties", percentComplete: Double(100))
            
        }
        
        
        
        // Chroma Con achievement
        if newFooledArray.count > 3 {
            
            let mappedItems = newFooledArray.map { ($0, 1) }
            let counts = Dictionary(mappedItems, uniquingKeysWith: +)
            let highestCount = counts.max { a, b in a.value < b.value }
            
            if highestCount?.value == 4 {
                
                GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.chroma_con", percentComplete: Double(100))
                
            }
            
        }
        
        
        // Soul Mates achievement
        if soulMatesArray.count > 3 {
            
            // could replace with if round 0 == round 1 == round 2 == round 3
            
            let mappedItems = soulMatesArray.map { ($0, 1) }
            let counts = Dictionary(mappedItems, uniquingKeysWith: +)
            let highestCount = counts.max { a, b in a.value < b.value }
            
            if highestCount?.value == 4 {
                
                GameKitHelper.sharedInstance.reportAchievement(identifier: "swatchthis.achievement.soul_mates", percentComplete: Double(100))
            
            }
            
        }
        

        return fooledTally
    
    }
    
    
    func saveFooledToHistory(newFooled: Int, fooledHistory: Int) {
        
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        
        struct FooledHistory: Codable {
            var fooled: Int
        }
                
        
        let updatedFooled = fooledHistory + newFooled
        
            // save the new history
             if let encoded = try? encoder.encode(FooledHistory(fooled: updatedFooled)) {
                 defaults.set(encoded, forKey: "FooledHistory")
                 print("saved fooled: \(updatedFooled)")
        }
        
        
    }
    
    
    
    func retrieveWonHistory() -> Int {
        
        
        let defaults = UserDefaults.standard
        
        struct WonHistory: Codable {
            var gamesWon: Int
        }

        if let won = defaults.object(forKey: "WonHistory") as? Data {
            let decoder = JSONDecoder()
            if let loadedWon = try? decoder.decode(WonHistory.self, from: won) {
                print("success loading won: \(loadedWon.gamesWon)")

                return loadedWon.gamesWon
            } else {
                return 0    // doing it like this in case this is a multithreaded operation
            }
        } else {
            return 0
        }
        
    }
    
    
    
    func saveWonToHistory(gameData: GameData, wonHistory: Int, localPlayer: String, localDisplayName: String) {
    
        var currentWin = 0
    
        // regardless of whether display names or Player X are coming through, we should catch it here
        if gameData.sortedPlayersArray[0] == localPlayer || gameData.sortedPlayersArray[0] == localDisplayName {
            
            // check that it's not a tie
            if gameData.finalPointsArray[0] > gameData.finalPointsArray[1] {
                currentWin = 1
            }
        }
    
        
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        
        struct WonHistory: Codable {
            var gamesWon: Int
        }
                
        
            // save the new history
             if let encoded = try? encoder.encode(WonHistory(gamesWon: currentWin+wonHistory)) {
                 defaults.set(encoded, forKey: "WonHistory")
                 print("saved won: \(currentWin+wonHistory)")
        }
        
        
        
    }

    
    
    
    
    // called when in GuessColors
    func isGameEnd(roundsFinished: Int, playerCount: Int, sortedPlayersArray: [String]) -> Bool {
        
        let returnBool = roundsFinished >= playerCount*2
        print("isGameEnd: \(returnBool)")
        
        return returnBool
        
    }
    
    
    
    func orderPlayersByPoints(playersDict: [String : Int]) -> [String] {
        
        
        //   let sortedPlayersDict = playersDict.sorted(by: <)
        
        let sortedPlayersDict = playersDict.sorted(by: { $0.value > $1.value })
        
        var sortedPlayersArray = [sortedPlayersDict[0].key]
        
        for index in 1...(sortedPlayersDict.count-1) {
            
            sortedPlayersArray.append(sortedPlayersDict[index].key)
        }
        
        return sortedPlayersArray
    }
    
    
    

    
    
    
    func createFinalPoints(playersDict: [String : Int]) -> [Int] {
        
        //   let sortedPlayersDict = playersDict.sorted(by: <)
        
        let sortedPlayersDict = playersDict.sorted(by: { $0.value > $1.value })
        
        var finalPoints = [sortedPlayersDict[0].value]
        
        for index in 1...(sortedPlayersDict.count-1) {
            
            finalPoints.append(sortedPlayersDict[index].value)
        }
        
        return finalPoints
    }
    
    
    
    func getPlayerInt(playerString: String) -> Int {
        
        
        let playerInt = Int(playerString.suffix(1)) ?? 0
        
        return playerInt
        
    }
    
    
    func getScoreDetailList(created: String, guessed: String, actual: String, playersThisRound: [[String: String]], userNames: [String: String]) -> [String] {
        
        var scoreDetailList = [String]()
        
        var createdVar = created
        if created == "Created color" {
            // then the game was ended prematurely, so we'll say "Created nothing"
            createdVar = "nothing"
        }
        
        
        var guessedVar = guessed
        if guessed == "Guessed color" {
            // then the game was ended prematurely, so we'll say "Guessed nothing"
            guessedVar = "nothing"
        }
        
        // every player should have a created and guessed for each color
        scoreDetailList.append("Created \(createdVar) and guessed \(guessedVar)")

        var counter = 0
        
        // if the player's created color was guessed by any other players, we'll add that to the score detail list
        for data in playersThisRound {
            
            if created == data["Guessed"] {
                
                let userName = userNames["Player \(counter+1)"] ?? "Player \(counter+1)"
                    
                scoreDetailList.append("Fooled \(userName)")
                
            }
            
            counter = counter + 1
        }
        
        
        // eat the end of the list show the points that this color earned this player
        
        var colorPoints = 0
        
        // if correct color guessed: 5 * playerCount + 5 points
        if guessed == actual {
            colorPoints += userNames.count*5+5
        }
        
        // 15 points per player fooled
        if scoreDetailList.count > 1 {
            colorPoints += (scoreDetailList.count-1)*15
        }
        
        // make it cheery if they earned points; don't rub it in if they didn't
        if colorPoints > 0 {
            scoreDetailList.append("+\(colorPoints) points!")
        }
        
        return scoreDetailList
        
        
    }
    
    
    func getIAPColors() -> [UInt32] {
        
        
        let filteredPalette = palette.masterPalette.filter { color in
          return color.pack == 1
        }
        
        
        var filteredColors = [UInt32]()
        
        for color in filteredPalette {
            
            filteredColors.append(color.hex)
        }
        
        return filteredColors
        
    }
    
    
    func getBaseGameColors() -> [UInt32] {
        
        
        let filteredPalette = palette.masterPalette.filter { color in
          return color.pack == 0
        }
        
        
        var filteredColors = [UInt32]()
        
        for color in filteredPalette {
            
            filteredColors.append(color.hex)
        }
        
        
        
        return filteredColors
        
    }
    
    
    
    
    
    /* // if using this need to import AVFoundation at top of file

    func textToSpeech(text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
      //  utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        
    }
    
    */
    
  
    
    
    
}



