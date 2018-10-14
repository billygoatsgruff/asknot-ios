//
//  TrendItem.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import MultiModelTableViewDataSource

class TrendItem: ConcreteMultiModelTableViewDataSourceItem<UITableViewCell> {
    var trend: Trend?
    
    init(identifier: String, _ trend: Trend?) {
        self.trend = trend
        super.init(identifier: identifier)
    }
    
    override func configureCell(_ cell: UITableViewCell) {
        cell.textLabel?.text = trend?.text
    }

}
