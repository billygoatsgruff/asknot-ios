//
//  RetweetTableViewCell.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/14/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import Prelude
import FunkyNetwork

protocol RetweetCellDelegate {
    func updatedTweet(tweet: TWTRTweet, with newTweet: TWTRTweet)
}

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetViewHolder: UIView!
    var tweetView: TWTRTweetView?
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var whyButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    var delegate: RetweetCellDelegate?
    
    var tweetId: TweetId!
    fileprivate var privateTweet: TWTRTweet?
    var tweet: TWTRTweet? {
        set(newTweet) {
            privateTweet = newTweet
            if let tweetView = tweetView {
                tweetView.showBorder = true
                tweetView.configure(with: newTweet)
            } else {
                tweetView = TWTRTweetView(tweet: newTweet, style: .regular)
                tweetViewHolder.translatesAutoresizingMaskIntoConstraints = false
                tweetView?.translatesAutoresizingMaskIntoConstraints = false
                tweetViewHolder.addSubview(tweetView!)
                tweetViewHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tweetView]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["tweetView": tweetView!]))
                tweetViewHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tweetView]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["tweetView": tweetView!]))
                contentView.setNeedsUpdateConstraints()
                contentView.updateConstraints()
                contentView.setNeedsLayout()
                contentView.layoutIfNeeded()
            }
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
        tweetView?.linkTextColor = UIColor.primary()
        tweetView?.showBorder = true
        
        if tweet?.isRetweeted ?? false {
            retweetButton.setImage(UIImage(named: "check"), for: .normal)
            primaryButtonStyle(retweetButton)
        }else{
            let retweetImage = UIImage(named: "retweet")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            retweetButton.setImage(retweetImage, for: .normal)
            floatingButtonStyle(retweetButton)
        }
        retweetButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        loadingIndicator?.isHidden = true
        
        reversePrimaryButtonStyle(whyButton)
    }
    
    func setIsLoading(isLoading: Bool) {
        if isLoading {
            retweetButton.isEnabled = false
            retweetButton.setImage(nil, for: .normal)
            loadingIndicator?.isHidden = false
            loadingIndicator?.startAnimating()
        } else {
            self.retweetButton.isEnabled = true
            self.loadingIndicator?.isHidden = true
        }
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
            self.setIsLoading(isLoading: true)
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
                        if let error = connectionError as NSError? {
                            DefaultNetworkErrorHandler().handleError(error)
                        }
                        self.setIsLoading(isLoading: false)
                    }
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                            let newTweet = TWTRTweet(jsonDictionary: json)
                            self.setIsLoading(isLoading: false)
                            self.delegate?.updatedTweet(tweet: self.tweet!, with: newTweet!)
                        } catch let jsonError as NSError {
                            print("json error: \(jsonError.localizedDescription)")
                            if let error = jsonError as NSError? {
                                DefaultNetworkErrorHandler().handleError(error)
                            }
                            self.setIsLoading(isLoading: false)
                        }
                    }
                }
            }
        }
    }
}

precedencegroup SingleTypeComposition {
    associativity: right
    higherThan: ForwardApplication
}
infix operator <>: SingleTypeComposition
func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

func applyShadow(_ view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = CGSize(width: 1, height: 1)
}

func makeCircular(_ view: UIView) {
    view.layer.cornerRadius = view.bounds.size.height / 2
}

let floatingStyle = makeCircular <> applyShadow

let floatingButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor.accent()
}

let primaryButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.reverse(), for: .normal)
    button.backgroundColor = UIColor.primary()
}

let reversePrimaryButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.primary(), for: .normal)
    button.backgroundColor = UIColor.reverse()
}

let reverseButtonStyle = makeCircular <> applyShadow <> { (button: UIButton) in
    button.setTitleColor(UIColor.accent(), for: .normal)
    button.backgroundColor = UIColor.reverse()
}
