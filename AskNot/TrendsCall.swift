//
//  TrendsCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 3/6/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Eson

class TrendsCall: AuthenticatedNetworkCall {
    
    override init() {
        super.init()
        endpoint = "/trends"
        httpMethod = "GET"
    }
    
    func fetch(completion: @escaping ((Array<Trend>?, NSError?) -> Void)) {
        execute({ (json, error) in
            if error == nil {
                let trends = Eson().fromJsonArray(json?["trends"] as! [[String : AnyObject]]?, clazz: Trend.self)
                completion(trends, nil)
            }else{
                completion(nil, error)
            }
        })
    }

}
