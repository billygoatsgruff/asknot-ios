//
//  AuthenticatedNetworkCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/22/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit

class AuthenticatedNetworkCall: BaseNetworkCall {
    
    override func execute(_ completion: @escaping ((AnyObject?, NSError?) -> Void)){
        if let apiKey = UserDefaults.standard.string(forKey: LoginCall.ApiKeyPref) {
            headers = ["X-Api-Key" : apiKey]
            
            super.execute(completion)
        } else {
            completion(nil, NSError(domain: "Auth", code: -1, userInfo: nil))
        }
    }
}
