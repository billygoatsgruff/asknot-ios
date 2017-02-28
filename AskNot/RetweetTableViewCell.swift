//
//  RetweetTableViewCell.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetView: TWTRTweetView!
    @IBOutlet weak var retweetButton: UIView!
    
    var tweetId: TweetId!
    fileprivate var privateTweet: TWTRTweet?
    var tweet: TWTRTweet? {
        set(newTweet) {
            privateTweet = newTweet
            tweetView.showBorder = false
            tweetView.configure(with: newTweet)
        }
        get {
            return privateTweet
        }
    }
    
    @IBAction func whyPressed() {
        let alert = UIAlertController(title: "Why this tweet", message: tweetId.why, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Oh, cool", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.show()
    }

    @IBAction func retweetPressed() {
        if let displayedTweet = tweet {
            let client = TWTRAPIClient.withCurrentUser()
            let retweetPathComponent = displayedTweet.isRetweeted ? "unretweet" : "retweet"
            let statusesRetweetEndpoint = "https://api.twitter.com/1.1/statuses/\(retweetPathComponent)/\(displayedTweet.tweetID).json?tweet_mode=extended"
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "POST", url: statusesRetweetEndpoint, parameters: nil, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    self.tweet = TWTRTweet(jsonDictionary: json as! [AnyHashable : Any])
                    
                    if let displayedTweet = self.tweet {
                        let retweetCall = RetweetCall()
                        if displayedTweet.isRetweeted {
                            retweetCall.create(tweetId: self.tweetId.objectId, completion: { (error) in
                                
                            })
                        }else{
                            retweetCall.delete(tweetId: self.tweetId.objectId, completion: { (error) in
                                
                            })
                        }
                    }
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
    }
}
