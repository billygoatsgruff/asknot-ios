//
//  TweetsCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/9/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Eson

class TweetsCall: AuthenticatedNetworkCall {
    
    override init() {
        super.init()
        endpoint = "/tweets"
        httpMethod = "GET"
    }
    
    func fetch(completion: @escaping ((Array<TweetId>?, NSError?) -> Void)) {
        execute({ (json, error) in
            if error == nil {
                let tweetIdHolders = Eson().fromJsonArray(json?["tweets"] as! [[String : AnyObject]]?, clazz: TweetId.self)
                completion(tweetIdHolders, nil)
            }else{
                completion(nil, error)
            }
        })
    }
}
