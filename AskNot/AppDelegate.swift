//
//  AppDelegate.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/30/20.
//

import UIKit
import OneSignal
import TwitterKit
import ANLib
import LUX

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let flowController = AppOpenFlowController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        TWTRTwitter.sharedInstance().start(withConsumerKey: "1OOTO1YJlYnFQofCIGknp2vg7", consumerSecret: "CHhqdbVNSN43u2wD3rMy45KAzdF9UjxVR11IVYCG262Zj9TQmj")
        OneSignal.initWithLaunchOptions(launchOptions, appId: "ff5947ed-2d02-4467-89a4-7c153289678a")
        
        UINavigationBar.appearance().barTintColor = UIColor.primary()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white];
        
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-ui_testing") {
            let primarySession = LUXUserDefaultsSession(host: Current.serverConfig.host, authHeaderKey: "X-Api-Key")
            primarySession.clearAuthValue()
        }
        
        // Override point for customization after application launch.
        let vc = flowController.initialVC()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc;
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
}

