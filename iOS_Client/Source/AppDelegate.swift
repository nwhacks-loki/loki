//
//  AppDelegate.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/13/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let facebookBlue = UIColor(hex: "3b5998")
        Alert.Defaults.Color.Info = facebookBlue
        
        let viewControllers: [UINavigationController] = [
            UINavigationController(rootViewController: TrainerViewController()),
            UINavigationController(rootViewController: CoreMLSyncViewController()),
            UINavigationController(rootViewController: EmotionReaderViewController()),
            UINavigationController(rootViewController: PictureFeedViewController())
        ]
            
        viewControllers.forEach {
            $0.navigationBar.barTintColor = facebookBlue
            $0.navigationBar.tintColor = .white
            $0.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor : UIColor.white
            ]
            $0.navigationBar.isTranslucent = false
        }
        
        let tabBarController = DynamicTabBarController(viewControllers: viewControllers)
        tabBarController.tabBar.activeTintColor = facebookBlue
        tabBarController.tabBar.backgroundColor = UIColor(hex: "dfe3ee")
        tabBarController.view.backgroundColor = UIColor(hex: "dfe3ee")
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
                
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

