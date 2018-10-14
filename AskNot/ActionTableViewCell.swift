//
//  ActionTableViewCell.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
