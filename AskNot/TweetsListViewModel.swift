//
//  TweetsListViewModel.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/21/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import Prelude
import ReactiveSwift
import ThryvUXComponents

protocol TweetsListViewModelDelegate {
    func finishedLoadingTweets(_ error: NSError?)
    func scrollToNextPage()
}

open class TweetsListViewModel: NSObject, RetweetCellDelegate {
    var delegate: TweetsListViewModelDelegate?
    var refresher: THUXRefreshableNetworkCallManager?
    var tweets: [TWTRTweet]?
    var tweetIds: [TweetId]?
    
    init(refresher: THUXRefreshableNetworkCallManager? = nil) {
        self.refresher = refresher
    }
    
    @objc open func fetchTweets() {
//        let tweetsCall = TweetsCall()
//        tweetsCall.fetch { (tweetIdHolders, error) in
//            if let e = error {
//                self.delegate?.finishedLoadingTweets(e)
//                return
//            }
//            self.tweetIds = tweetIdHolders
//            if let tweetIds = tweetIdHolders {
//                var tweetIdValues = tweetIds.map { $0.twitterId }
//                self.fetchTWTRTweets(tweetIdValues: tweetIdValues)
//            } else {
//                self.delegate?.finishedLoadingTweets(nil)
//            }
//        }
    }
    
    open func fetchTWTRTweets(tweetIdValues: Array<String>) {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            var clientError : NSError?
            let request = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/statuses/lookup.json?tweet_mode=extended&id=\(tweetIdValues.joined(separator: ","))", parameters: nil, error: &clientError)
            client.sendTwitterRequest(request, completion: { (response, data, error) in
                if let jsonData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)
                        var tweets: [TWTRTweet] = [TWTRTweet]()
                        for tweetJson in json as! [[String : AnyObject]] {
                            tweets.append(TWTRTweet(jsonDictionary: tweetJson)!)
                        }
                        self.tweets = tweets
                    }catch let error as NSError {
                        print(error)
                    }
                    self.delegate?.finishedLoadingTweets(nil)
                }
            })
        }
    }
    
    func updatedTweet(tweet: TWTRTweet, with newTweet: TWTRTweet) {
        refresher?.refresh()
        delegate?.scrollToNextPage()
    }

}
