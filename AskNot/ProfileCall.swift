//
//  ProfileCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/12/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import Eson

class ProfileCall: AuthenticatedNetworkCall {
    
    override init() {
        super.init()
        endpoint = "/current_user"
        httpMethod = "GET"
    }
    
    func fetch(completion: @escaping ((User?, NSError?) -> Void)) {
        execute({ (json, error) in
            if error == nil {
                let user = Eson().fromJsonDictionary(json?["user"] as! [String : AnyObject]?, clazz: User.self)
                completion(user, nil)
            }else{
                completion(nil, error)
            }
        })
    }

}
