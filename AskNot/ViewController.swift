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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        
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
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        VersionChecker.isVersion(VersionChecker.appVersionString()) { (isCurrent) in
            if isCurrent {
                if UserDefaults.standard.string(forKey: LoginCall.ApiKeyPref) != nil {
                    self.performSegue(withIdentifier: "tweetlist", sender: self)
                }
            }else{
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
        loginCall.login(session: session) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "tweetlist", sender: self)
            }
        }
    }

}
