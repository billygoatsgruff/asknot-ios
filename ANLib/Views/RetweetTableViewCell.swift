//
//  RetweetTableViewCell.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/14/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import LithoOperators
import Prelude
import FunNet
import Combine

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetViewHolder: UIView!
    var tweetView: TWTRTweetView?
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var whyButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    var cancelBag = Set<AnyCancellable>()
    var responder: NetworkResponderProtocol?
    
    var onRetweetPressed: (RetweetTableViewCell) -> Void = indicateActivity <> incrementServerRetweets <> toggleRetweet
    var onRetweeted: (() -> Void)?
    var onWhyPressed: (RetweetTableViewCell) -> Void = showWhy(_:)
    var onStartLoading: (RetweetTableViewCell) -> Void = startLoading(_:)
    var onEndLoading: (RetweetTableViewCell) -> Void = endLoading(_:)
    
    var isLoading: Bool = false { didSet { isLoading ? onStartLoading(self) : onEndLoading(self) }}
    var tweetId: TweetId!
    
    @IBAction func whyPressed() { onWhyPressed(self) }
    @IBAction func retweetPressed() { onRetweetPressed(self) }
}

func configureTweetCell(tweet: TweetId, cell: RetweetTableViewCell, tweetUpdated: @escaping () -> Void) {
    cell.tweetId = tweet
    cell.onRetweeted = tweetUpdated
    
    if let tweetView = cell.tweetView {
        tweetView.showBorder = true
        tweetView.configure(with: tweet.tweet)
    } else {
        cell.tweetView = TWTRTweetView(tweet: tweet.tweet, style: .regular)
        cell.tweetView?.translatesAutoresizingMaskIntoConstraints = false
        cell.tweetViewHolder.addSubview(cell.tweetView!)
        cell.tweetViewHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tweetView]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["tweetView": cell.tweetView!]))
        cell.tweetViewHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tweetView]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["tweetView": cell.tweetView!]))
        cell.contentView.setNeedsUpdateConstraints()
        cell.contentView.updateConstraints()
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
    }
    
    styleTweetCell(cell)
}

func styleTweetCell(_ cell: RetweetTableViewCell) {
    cell.tweetView?.linkTextColor = UIColor.primary()
    cell.tweetView?.showBorder = true
    
    cell.tweetViewHolder.translatesAutoresizingMaskIntoConstraints = false
    
    if cell.tweetId.tweet?.isRetweeted ?? false {
        cell.retweetButton.setImage(UIImage(named: "check"), for: .normal)
        primaryButtonStyle(cell.retweetButton)
    }else{
        let retweetImage = UIImage(named: "retweet")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.retweetButton.setImage(retweetImage, for: .normal)
        floatingButtonStyle(cell.retweetButton)
    }
    cell.retweetButton.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    
    cell.loadingIndicator?.isHidden = true
    
    reversePrimaryButtonStyle(cell.whyButton)
}

func startLoading(_ cell: RetweetTableViewCell) {
    cell.retweetButton.isEnabled = false
    cell.retweetButton.setImage(nil, for: .normal)
    cell.loadingIndicator?.isHidden = false
    cell.loadingIndicator?.startAnimating()
}

func endLoading(_ cell: RetweetTableViewCell) {
    cell.retweetButton.isEnabled = true
    cell.loadingIndicator?.isHidden = true
}

func showWhy(_ cell: RetweetTableViewCell) {
    let alert = UIAlertController(title: "Why this tweet", message: cell.tweetId.why, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Oh, cool", style: .cancel, handler: { (action) in
        alert.dismiss(animated: true, completion: nil)
    }))
    cell.findViewController()?.presentAnimated(alert)
}

func zipResults<Root, T, U>(_ f: @escaping (Root) -> T, _ g: @escaping (Root) -> U) -> (Root) -> (T, U) { { (f($0), g($0)) }}
func zipResults<Root, T, U, V>(_ f: @escaping (Root) -> T, _ g: @escaping (Root) -> U, _ h: @escaping (Root) -> V) -> (Root) -> (T, U, V) {{ (f($0), g($0), h($0)) }}

let indicateActivity = set(\RetweetTableViewCell.isLoading, true)
let incrementServerRetweets = zipResults(\RetweetTableViewCell.tweetId.tweet?.isRetweeted, \RetweetTableViewCell.tweetId?.id) >>> logRetweet
let toggleRetweet = zipResults(^\RetweetTableViewCell.tweetId.tweet?.tweetID, ^\RetweetTableViewCell.tweetId.tweet?.isRetweeted, retweetResponder) >>> toggleRetweeted(for:_:netResponder:)

func retweetResponder(_ cell: RetweetTableViewCell) -> NetworkResponderProtocol {
    let combineResponder = CombineNetworkResponder()
    combineResponder.$response.dropFirst().sink { [weak cell] _ in cell?.isLoading = false }.store(in: &cell.cancelBag)
    combineResponder.$data.skipNils().sink { [weak cell] data in
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
            let _ = TWTRTweet(jsonDictionary: json)
            cell?.onRetweeted?()
        } catch let jsonError as NSError {
            print("json error: \(jsonError.localizedDescription)")
        }
    }.store(in: &cell.cancelBag)
    cell.responder = combineResponder
    return combineResponder
}

func logRetweet(_ isRetweeted: Bool?, _ id: Int64?) { if let bool = isRetweeted, let id = id { logRetweet(bool, id)} }
func logRetweet(_ isRetweeted: Bool, _ id: Int64) {
    netCall(from: isRetweeted ? deleteRetweetEndpoint(retweetId: id) : retweetsPostEndpoint(body: Retweet(tweetId: id))).fire()
}

func toggleRetweeted(for id: String?, _ isRetweeted: Bool?, netResponder: NetworkResponderProtocol) { if let id = id, let bool = isRetweeted { toggleRetweeted(for: id, bool, netResponder: netResponder) }}
func toggleRetweeted(for id: String, _ isRetweeted: Bool, netResponder: NetworkResponderProtocol) {
    if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
        let retweetPath = isRetweeted ? "unretweet" : "retweet"
        let statusesRetweetEndpointString = "statuses/\(retweetPath)/\(id).json?tweet_mode=extended"
        let twitterUrlString = Current.twitterServerConfig.urlString(for: statusesRetweetEndpointString, getParams: [:])

        let client = TWTRAPIClient(userID: userID)
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "POST", urlString: twitterUrlString, parameters: nil, error: &clientError)
        
        client.sendTwitterRequest(request, completion: completionToTwitterCompletion(responderToCompletion(responder: netResponder)))
    }
}

func completionToTwitterCompletion(_ completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> TWTRNetworkCompletion {
    return { completion($1, $0, $2) }
}
