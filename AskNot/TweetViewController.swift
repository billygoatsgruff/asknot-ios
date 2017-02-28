//
//  TweetViewController.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/8/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Eson
import TwitterKit

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweets: [TWTRTweet]?
    var tweetIds: [TweetId]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tweets"
        
        tweetsTableView.tableFooterView = UIView(frame: CGRect.zero)
        tweetsTableView.estimatedRowHeight = 100
        tweetsTableView.rowHeight = UITableViewAutomaticDimension

        fetchTweetIds()
    }
    
    func fetchTweetIds() {
        let tweetsCall = TweetsCall()
        tweetsCall.fetch { (tweetIdHolders, error) in
            if let e = error {
                if e.domain == "Server" && e.code == 401 {
                    UserDefaults.standard.set(nil, forKey: LoginCall.ApiKeyPref)
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            self.tweetIds = tweetIdHolders
            if let tweetIds = tweetIdHolders {
                var tweetIdValues = Array<String>()
                for tweetId in tweetIds {
                    tweetIdValues.append(String(tweetId.twitterId))
                }
                self.fetchTweets(tweetIdValues: tweetIdValues)
            }
        }
    }
    
    func fetchTweets(tweetIdValues: Array<String>) {
        let client = TWTRAPIClient.withCurrentUser()
        client.loadTweets(withIDs: tweetIdValues) { (tweets, error) in
            self.tweets = tweets
            self.tweetsTableView.delegate = self
            self.tweetsTableView.dataSource = self
            self.tweetsTableView.reloadData()
        }
    }
    
    //MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets != nil) ? tweets!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RetweetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "retweetCell", for: indexPath) as! RetweetTableViewCell
        
        cell.tweetId = tweetIds?[indexPath.row]
        cell.tweet = tweets?[indexPath.row]
        
        return cell
    }
    
    

}
