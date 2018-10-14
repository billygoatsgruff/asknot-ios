//
//  TweetsTableViewDataSource.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/21/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit

class TweetsTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var retweetDelegate: RetweetCellDelegate!
    var tweets: [TWTRTweet]?
    var tweetIds: [TweetId]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RetweetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "retweetCell", for: indexPath) as! RetweetTableViewCell
        
        cell.tweetId = tweetIds?[indexPath.row]
        cell.tweet = tweets?[indexPath.row]
        cell.delegate = retweetDelegate
        
        return cell
    }

}
