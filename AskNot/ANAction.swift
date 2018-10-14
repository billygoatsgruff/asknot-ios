//
//  ANAction.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit

class ANAction {
    var prompt: String = ""
    var buttonText: String = ""
    var action: () -> Void = {}
}

class UrlAction: ANAction {
    var url = ""
    
    override init() {
        super.init()
        action = {
            UIApplication.shared.open(URL(string: self.url)!, options: [:], completionHandler: nil)
        }
    }
}

class RateAction: UrlAction {
    override init() {
        super.init()
        prompt = "Rate this app!"
        buttonText = "Go to App Store"
        url = "https://itunes.apple.com/us/app/asknot/id1205213169?ls=1&mt=8"
    }
}

class ShareAction: ANAction {
    override init() {
        super.init()
        prompt = "Share the app!"
        buttonText = "Share now"
        action = {
            let url = URL(string: "https://asknot.thryvinc.com/")!
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            show(viewController: activityViewController)
        }
    }
}

class HelpOutAction: UrlAction {
    override init() {
        super.init()
        prompt = "Sign up to help out!"
        buttonText = "Go to sign up form"
        url = "https://asknot.thryvinc.com/helpout"
    }
}

class OpenTwitterAction: UrlAction {
    override init() {
        super.init()
        prompt = "Write your own tweets on these topics!"
        buttonText = "Open Twitter"
        url = "https://twitter.com"
    }
}
