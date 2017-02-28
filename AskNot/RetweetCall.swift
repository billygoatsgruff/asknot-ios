//
//  RetweetCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/22/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Eson

class RetweetCall: AuthenticatedNetworkCall {
    
    override init() {
        super.init()
        endpoint = "/retweets"
    }
    
    func create(tweetId: Int, completion: @escaping ((NSError?) -> Void)) {
        httpMethod = "POST"
        
        var json = Dictionary<String, Int>();
        json["tweet_id"] = tweetId
        do {
            try postData = JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let parseError as NSError {
            NSLog("Parse error: %@", parseError.localizedDescription);
        }
        
        execute({ (json, error) in
            if error == nil {
                completion(nil)
            }else{
                completion(error)
            }
        })
    }
    
    func delete(tweetId: Int, completion: @escaping ((NSError?) -> Void)) {
        httpMethod = "DELETE"
        endpoint = "retweets/\(tweetId)"
        
        execute({ (json, error) in
            if error == nil {
                completion(nil)
            }else{
                completion(error)
            }
        })
    }

}
