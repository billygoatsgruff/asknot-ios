//
//  TrendsDataSource.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/21/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

class TrendsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var trends: [Trend]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = trends?[indexPath.row].text
        
        return cell
    }

}
