//
//  ANAction.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit

struct ActionModel {
    var title: String = "Woohoo! You're done! (For now)"
    var subtitle: String = "We'll send you more tweets soon."
    var prompt: String = "Want to do more?"
    var actionText: String = ""
    var buttonText: String = ""
}

public class ANAction {
    var title: String = "Woohoo! You're done! (For now)"
    var subtitle: String = "We'll send you more tweets soon."
    var prompt: String = "Want to do more?"
    var actionText: String = ""
    var buttonText: String = ""
    var action: () -> Void = {}
    
    init(_ model: ActionModel?) {
        if let model = model {
            title = model.title
            subtitle = model.subtitle
            prompt = model.prompt
            actionText = model.actionText
            buttonText = model.buttonText
        }
    }
    
    @objc public func executeAction() {
        action()
    }
}

class UrlAction: ANAction {
    var url = ""
    
    override init(_ model: ActionModel? = nil) {
        super.init(model)
        action = {
            UIApplication.shared.open(URL(string: self.url)!, options: [:], completionHandler: nil)
        }
    }
}

class RateAction: UrlAction {
    override init(_ model: ActionModel? = nil) {
        if model == nil {
            var model = ActionModel()
            model.actionText = "Rate this app!"
            model.buttonText = "Go to App Store"
            super.init(model)
        } else {
            super.init(model)
        }
        url = "https://itunes.apple.com/us/app/asknot/id1205213169?ls=1&mt=8"
    }
}

class ShareAction: ANAction {
    init(presenter: UIViewController, _ model: ActionModel? = nil) {
        if model == nil {
            var model = ActionModel()
            model.actionText = "Share the app!"
            model.buttonText = "Share now"
            super.init(model)
        } else {
            super.init(model)
        }
        action = {
            let url = URL(string: "https://asknot.thryvinc.com/")!
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            presenter.present(activityViewController, animated: true, completion: nil)
            netCall(from: currentUserPutEndpoint(body: User(hasShared: true))).fire()
        }
    }
}

class HelpOutAction: UrlAction {
    override init(_ model: ActionModel? = nil) {
        if model == nil {
            var model = ActionModel()
            model.actionText = "Sign up to help out!"
            model.buttonText = "Go to sign up form"
            super.init(model)
        } else {
            super.init(model)
        }
        url = "https://asknot.app/helpout"
    }
}

class OpenTwitterAction: UrlAction {
    override init(_ model: ActionModel? = nil) {
        if model == nil {
            var model = ActionModel()
            model.actionText = "Write your own tweets on these topics!"
            model.buttonText = "Open Twitter"
            super.init(model)
        } else {
            super.init(model)
        }
        url = "https://twitter.com"
    }
}

func chooseAction(_ vc: UIViewController) -> ANAction {
    let actions = [ShareAction(presenter: vc), /*RateAction(), HelpOutAction(),*/ OpenTwitterAction()]
    let index = Int(arc4random_uniform(UInt32(actions.count)))
    if index == 1 { // only choose rate 1 out of 200 times, ish
        let odds = Int(arc4random_uniform(UInt32(200)))
        if odds != 0 {
            return chooseAction(vc)
        }
    }
    return actions[index]
}
