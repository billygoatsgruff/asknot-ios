//
//  RetweetTableViewCell.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/14/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit

protocol RetweetCellDelegate {
    func updatedTweet(tweet: TWTRTweet, with newTweet: TWTRTweet)
}

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetView: TWTRTweetView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var whyButton: UIButton!
    
    var delegate: RetweetCellDelegate?
    
    var tweetId: TweetId!
    fileprivate var privateTweet: TWTRTweet?
    var tweet: TWTRTweet? {
        set(newTweet) {
            privateTweet = newTweet
            tweetView.showBorder = true
            tweetView.configure(with: newTweet)
            styleViews()
        }
        get {
            return privateTweet
        }
    }
    
    override func didMoveToWindow() {
        styleViews()
    }
    
    func styleViews() {
        tweetView.linkTextColor = UIColor.primary()
        
        retweetButton.makeCircular().applyShadow()
        if tweet?.isRetweeted ?? false {
            retweetButton.setImage(UIImage(named: "check"), for: .normal)
            retweetButton.backgroundColor = UIColor.primary()
        }else{
            let retweetImage = UIImage(named: "retweet")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            retweetButton.setImage(retweetImage, for: .normal)
            retweetButton.backgroundColor = UIColor.accent()
        }
        retweetButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        whyButton
            .makeCircular()
            .applyShadow()
    }
    
    @IBAction func whyPressed() {
        let alert = UIAlertController(title: "Why this tweet", message: tweetId.why, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Oh, cool", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.show()
    }
    
    @IBAction func retweetPressed() {
        if let displayedTweet = tweet {
            if let displayedTweet = self.tweet, let objectId = self.tweetId.id {
                if !displayedTweet.isRetweeted {
                    RetweetCall(tweetId: objectId).fire()
                }else{
                    UnRetweetCall(tweetId: objectId).fire()
                }
            }
            
            if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
                let client = TWTRAPIClient(userID: userID)
                let retweetPathComponent = displayedTweet.isRetweeted ? "unretweet" : "retweet"
                let statusesRetweetEndpoint = "https://api.twitter.com/1.1/statuses/\(retweetPathComponent)/\(displayedTweet.tweetID).json?tweet_mode=extended"
                var clientError : NSError?
                
                let request = client.urlRequest(withMethod: "POST", urlString: statusesRetweetEndpoint, parameters: nil, error: &clientError)
                
                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                    if connectionError != nil {
                        print("Error: \(connectionError.debugDescription)")
                    }
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                            let newTweet = TWTRTweet(jsonDictionary: json)
                            self.delegate?.updatedTweet(tweet: self.tweet!, with: newTweet!)
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

extension UIView {
    func applyShadow() -> UIView {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        return self
    }
    
    func makeCircular() -> UIView {
        self.layer.cornerRadius = self.bounds.size.height / 2
        return self
    }
}
