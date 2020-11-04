//
//  ActionItem.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import MultiModelTableViewDataSource
import Prelude

class ActionItem: ConcreteMultiModelTableViewDataSourceItem<ActionTableViewCell> {
    let sharePresenter: UIViewController
    lazy var action = chooseAction()
    
    init(identifier: String, sharePresenter: UIViewController) {
        self.sharePresenter = sharePresenter
        super.init(identifier: identifier)
    }
    
    override func configureCell(_ cell: UITableViewCell) {
        if let cell = cell as? ActionTableViewCell {
            cell |> styleActionCell <> setupAction
        }
    }
    
    func styleActionCell(_ cell: ActionTableViewCell) {
        cell.contentView.backgroundColor = UIColor.primaryDark()
        cell.labels.forEach { (label) in
            label.textColor = UIColor.reverse()
        }
        cell.actionButton |> ctaButtonStyle
    }
    
    func setupAction(_ cell: ActionTableViewCell) {
        cell.titleLabel.text = action.title
        cell.subtitleLabel.text = action.subtitle
        cell.promptLabel.text = action.prompt
        cell.actionLabel.text = action.actionText
        cell.actionButton.setTitle(action.buttonText, for: .normal)
        cell.actionButton.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
    }
    
    func chooseAction() -> ANAction {
        let actions = [ShareAction(presenter: sharePresenter), RateAction(), HelpOutAction(), OpenTwitterAction()]
        let index = Int(arc4random_uniform(UInt32(actions.count)))
        if index == 1 { // only choose rate 1 out of 200 times, ish
            let odds = Int(arc4random_uniform(UInt32(200)))
            if odds != 0 {
                return chooseAction()
            }
        }
        return actions[index]
    }
    
    @objc func executeAction() {
        action.action()
    }
}

let ctaButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.accent(), for: .normal)
    button.backgroundColor = UIColor.reverse()
}
