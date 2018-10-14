//
//  AskNotServerConfig.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import FunkyNetwork

class AskNotServerConfig {
    private static let scheme = "https"
    private static let host = "asknot.herokuapp.com"
    private static let apiRoute = "api/v1"
    
    public static let production = ServerConfiguration(scheme: scheme, host: host, apiRoute: apiRoute)
    public static let stub = ServerConfiguration(shouldStub: true, scheme: scheme, host: host, apiRoute: apiRoute)
    
    public static let current = production
}

func notify(error: NSError) {
    let alert = UIAlertController(title: "\(error.domain) Error \(error.code)", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
        alert.dismiss(animated: true, completion: nil)
    }))
    alert.show()
}

extension UIAlertController {
    public func show(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindow.Level.alert
        
        if let rootViewController = window.rootViewController {
            window.makeKeyAndVisible()
            
            rootViewController.present(self, animated: flag, completion: completion)
        }
    }
}

func show(viewController: UIViewController) {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UIViewController()
    window.backgroundColor = UIColor.clear
    window.windowLevel = UIWindow.Level.alert
    
    if let rootViewController = window.rootViewController {
        window.makeKeyAndVisible()
        
        rootViewController.present(viewController, animated: true, completion: nil)
    }
}
