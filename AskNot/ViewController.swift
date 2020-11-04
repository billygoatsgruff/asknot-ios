//
//  ViewController.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import LUX

class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        
//        let store = TWTRTwitter.sharedInstance().sessionStore
//        store.reload()
//        for case let session as TWTRSession in store.existingUserSessions() {
//            store.logOutUserID(session.userID)
//        }
        
        let logInButton = TWTRLogInButton { (session, twitterError) in
            if let err = twitterError {
                print("Twitter Login Error: \(String.init(describing: err.localizedDescription))")
                return
            }
            if let unwrappedSession = session {
//                let store = TWTRTwitter.sharedInstance().sessionStore
//                store.reload()
//                store.logOutUserID(unwrappedSession.userID)
//
//                TWTRTwitter.sharedInstance().logIn(completion: { (session2, error) in
//                    if let unwrappedSession = session2 {
                        self.login(session: unwrappedSession)
//                    }
//                })
            }
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        VersionChecker.isVersion(VersionChecker.appVersionString()) { (isCurrent) in
            if isCurrent {
                if UserDefaults.standard.string(forKey: LoginCall.ApiKeyPref) != nil {
                    LUXSessionManager.session = LUXUserDefaultsSession(authDefaultsKey: LoginCall.ApiKeyPref, authHeaderKey: "X-Api-Key")
                    self.performSegue(withIdentifier: "tweetlist", sender: self)
                }
            } else {
                let alertController = UIAlertController(title: "New version!", message: "New features and improvements are waiting!", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Yay!", style: UIAlertAction.Style.default, handler: { (action) in
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/us/app/asknot/id1205213169?ls=1&mt=8")!, options: [:], completionHandler: nil)
                }))
                alertController.show()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func login(session: TWTRSession) {
        let loginCall = LoginCall()
        loginCall.httpResponseSignal.observeValues { response in
            if response.statusCode < 300 {
                self.performSegue(withIdentifier: "tweetlist", sender: self)
            }
        }
        loginCall.login(session: session)
    }

}
