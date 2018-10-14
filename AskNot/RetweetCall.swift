//
//  RetweetCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/22/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import ThryvUXComponents
import FunkyNetwork

class RetweetCall: THUXAuthenticatedNetworkCall {
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, tweetId: Int, stubHolder: StubHolderProtocol? = nil) {
        var postData: Data?
        var json = Dictionary<String, Int>();
        json["tweet_id"] = tweetId
        do {
            try postData = JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let parseError as NSError {
            NSLog("Parse error: %@", parseError.localizedDescription);
        }

        super.init(configuration: configuration, httpMethod: "POST", httpHeaders: [:], endpoint: "retweets", postData: postData, stubHolder: nil)
    }

}
