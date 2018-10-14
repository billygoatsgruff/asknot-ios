//
//  TweetItem.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/13/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import MultiModelTableViewDataSource
import TwitterKit

class TweetItem: ConcreteMultiModelTableViewDataSourceItem<RetweetTableViewCell> {
    var retweetDelegate: RetweetCellDelegate?
    var tweetId: TweetId!
    var tweet: TWTRTweet?
    
    init(_ identifier: String = "retweetCell", _ tweetId: TweetId?, _ tweet: TWTRTweet?, _ retweetDelegate: RetweetCellDelegate?) {
        self.tweetId = tweetId
        self.tweet = tweet
        self.retweetDelegate = retweetDelegate
        
        super.init(identifier: identifier)
    }
    
    override func configureCell(_ cell: UITableViewCell) {
        if let cell = cell as? RetweetTableViewCell {
            cell.tweetId = tweetId
            cell.tweet = tweet
            cell.delegate = retweetDelegate
        }
    }

}
