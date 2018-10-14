//
//  AppDelegate.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import Crashlytics
import OneSignal
import SBNag_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let nag = SBNagService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self, Answers.self, TWTRTwitter.self])
        OneSignal.initWithLaunchOptions(launchOptions, appId: "ff5947ed-2d02-4467-89a4-7c153289678a")
        
        UINavigationBar.appearance().barTintColor = UIColor.primary()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];

        let rateNagtion = SBNagtion()
        rateNagtion.defaultsKey = "rate"
        rateNagtion.title = "Thanks for your support!"
        rateNagtion.message = "Wanna be EXTRA awesome and rate this app? (This helps us get more downloads, and hence, more amplifying power)"
        rateNagtion.yesAction = { () in
            //TODO
        }
        
        let shareNagtion = SBNagtion()
        shareNagtion.defaultsKey = "share"
        shareNagtion.title = "Spread the word!"
        shareNagtion.message = "The more people who use the app, the more we can spread liberal values. \nCan you help?"
        shareNagtion.yesAction = { () in
            //TODO
        }
        
        let subscribeNagtion = SBNagtion()
        subscribeNagtion.defaultsKey = "share"
        subscribeNagtion.title = "Remember, remember, the 8th of November"
        subscribeNagtion.message = "We desperately need your help to stay up and running. \nCan you subscribe for $11.08 a month?"
        subscribeNagtion.yesAction = { () in
            //TODO
        }
        
        nag.nagtions.append(contentsOf: [rateNagtion, shareNagtion, subscribeNagtion])
//        nag.startCountDown()
        
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

