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
    lazy var action = chooseAction()
    
    override func configureCell(_ cell: UITableViewCell) {
        if let cell = cell as? ActionTableViewCell {
            cell |> (styleActionCell >>> setupAction)
        }
    }
    
    func styleActionCell(_ cell: ActionTableViewCell) -> ActionTableViewCell {
        cell.contentView.backgroundColor = UIColor.primaryDark()
        cell.labels.forEach { (label) in
            label.textColor = UIColor.reverse()
        }
        cell.actionButton.setTitleColor(UIColor.accent(), for: .normal)
        cell.actionButton.backgroundColor = UIColor.reverse()
        cell.actionButton.makeCircular()
        return cell
    }
    
    func setupAction(_ cell: ActionTableViewCell) -> ActionTableViewCell {
        cell.actionLabel.text = action.prompt
        cell.actionButton.setTitle(action.buttonText, for: .normal)
        cell.actionButton.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
        return cell
    }
    
    func chooseAction() -> ANAction {
        let actions = [ShareAction(), RateAction(), HelpOutAction(), OpenTwitterAction()]
        return actions[Int(arc4random_uniform(UInt32(actions.count)))]
    }
    
    @objc func executeAction() {
        action.action()
    }
}
