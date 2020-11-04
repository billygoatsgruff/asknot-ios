//
//  ActionTableViewCell.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import Prelude

class ActionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var labels: [UILabel]!
}

func configureActionCell(_ action: ANAction, _ cell: ActionTableViewCell) {
    cell.titleLabel.text = action.title
    cell.subtitleLabel.text = action.subtitle
    cell.promptLabel.text = action.prompt
    cell.actionLabel.text = action.actionText
    cell.actionButton.setTitle(action.buttonText, for: .normal)
    cell.actionButton.addTarget(action, action: #selector(ANAction.executeAction), for: .touchUpInside)
    
    styleActionCell(cell)
}

func styleActionCell(_ cell: ActionTableViewCell) {
    cell.contentView.backgroundColor = UIColor.primaryDark()
    cell.labels.forEach { (label) in
        label.textColor = UIColor.reverse()
    }
    cell.actionButton |> ctaButtonStyle
}
