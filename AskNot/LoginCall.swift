//
//  LoginCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/9/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import Eson

class LoginCall: BaseNetworkCall {
    public static let ApiKeyPref = "api_key"
    
    override init() {
        super.init()
        endpoint = "/sessions"
        httpMethod = "POST"
    }
    
    func login(session: TWTRSession, completion: @escaping ((User?, NSError?) -> Void)) {
        var json = Dictionary<String, String>();
        json["access_token"] = session.authToken
        json["access_token_secret"] = session.authTokenSecret
        do {
            try postData = JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let parseError as NSError {
            NSLog("Parse error: %@", parseError.localizedDescription);
        }
        
        execute({ (object, error) in
            if let json = object {
                let user = Eson().fromJsonDictionary(json as? [String : AnyObject], clazz: User.self)
                UserDefaults.standard.set(user?.apiKey, forKey: LoginCall.ApiKeyPref)
                completion(user, nil);
            }
        })
    }

}
