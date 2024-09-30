//
//  SceneDelegate.swift
//  Swatch This
//
//  Created by Russ Hooper on 7/8/20.
//  Copyright © 2020 Radio Silence. All rights reserved.
//

import UIKit
import SwiftUI
import StoreKit


var isiOSAppOnMac = false
var colorLocalized = "colour"
var colorLocalizedCap = "Colour"


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        let productIDs = [
            "swatchthis.IAP.palettepack1"
            ]
        
        StoreManager.sharedInstance.getProducts(productIDs: productIDs)
        SKPaymentQueue.default().add(StoreManager.sharedInstance)
        
        
        if #available(iOS 14.0, *) {
            isiOSAppOnMac = ProcessInfo.processInfo.isiOSAppOnMac
        }
        
        
        let locale = Locale.current
        
        if locale.region?.identifier == "US" {
            colorLocalized = "color"
            colorLocalizedCap = "Color"
        }
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
          
            window.rootViewController = UIHostingController(rootView:
                                                                SwitcherView()
                                                            //    AnimationPlayground5()
                                                                .environmentObject(TransitionSwatches())

                                                                .environmentObject(ViewRouter.sharedInstance)
                                                                .environmentObject(GameData())
                                                                .environmentObject(GameKitHelper.sharedInstance)
                                                                //    .environmentObject(StoreManager.sharedInstance)
                                                             //   .onAppear(perform: {
                                                                    

                                                             //   })
                                                            
            )
 
            
            // for Quick Actions when the app is not already running
            /* https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-uiapplicationshortcutitem-quick-action-for-3d-touch
             */
            // need to also add Quick Action buttons in info.plist using this link ^
            /*
            if let shortcutItem = connectionOptions.shortcutItem {

                print("test 2")

                if shortcutItem.type == "com.radiosilence.Swatch.adduser" {
                    // shortcut was triggered!
                                        
                    print("test 3")
                    
                    ViewRouter.sharedInstance.currentPage = "loading"
                    
                }
            }
            */
            
           
            
            // for Game Center
            PopupControllerMessage.PresentAuthentication
                .addHandlerForNotification(
                    self,
                    handler: #selector(SceneDelegate
                        .showAuthenticationViewController))
            

            PopupControllerMessage.GameCenter
            .addHandlerForNotification(
                self,
                handler: #selector(SceneDelegate
                    .showGameCenterTurnBasedViewController))
            
          
            
            self.window = window
            
            //set the tintColor to be applied globally
            //  self.window?.tintColor = UIColor.red
            
            window.makeKeyAndVisible()
        }
    }
    
    // for Quick Actions when the app is already running
    /*
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        self.handleShortCutItem(shortcutItem: shortcutItem)
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem)
    {
        //Get type string from shortcutItem
        if shortcutItem.type == "com.radiosilence.Swatch.adduser" {
           
            ViewRouter.sharedInstance.currentPage = "loading"
            
        }
    }
    */
    
    
    // presents the authentication screen
       @objc func showAuthenticationViewController() {
        
        
           if let authenticationViewController =
               GameKitHelper.sharedInstance.authenticationViewController {
               
               self.window?.rootViewController?.present(
                   authenticationViewController, animated: true)
               { GameKitHelper.sharedInstance.enabled  =
                   GameKitHelper.sharedInstance.gameCenterEnabled }
           }
       }
    

    
    // presents the turn-based matchmaking screen
    @objc func showGameCenterTurnBasedViewController() {
                
        
        if let gameCenterTurnBasedViewController =
            GameKitHelper.sharedInstance.gameCenterTurnBasedViewController {
            self.window?.rootViewController?.present(
                gameCenterTurnBasedViewController,
                animated: true,
                completion: nil)
        }
        /*
        if let gameCenterViewControllerTest =
            GameKitHelper.sharedInstance.gameCenterViewControllerTest {
            self.window?.rootViewController?.present(
                gameCenterViewControllerTest,
                animated: true,
                completion: nil)
        }
        */
    //    .environmentObject(ViewRouter())

    }
    
    
   
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // if in the Game Center loading screen, will cause the app to get stuck upon resume. So, move to menu
        
        if ViewRouter.sharedInstance.currentPage == "loading" {
            ViewRouter.sharedInstance.currentPage = "menu"
        }
    }
    
    
}

