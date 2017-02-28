//
//  ViewController.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import Eson

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logInButton = TWTRLogInButton { (session, twitterError) in
            if let unwrappedSession = session {
                self.login(session: unwrappedSession)
            }
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.string(forKey: LoginCall.ApiKeyPref) != nil {
            performSegue(withIdentifier: "tweetlist", sender: self)
        }
    }
    
    func login(session: TWTRSession) {
        let loginCall = LoginCall()
        loginCall.login(session: session) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "tweetlist", sender: self)
            }
        }
    }

}
