//
//  LoginCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/9/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import TwitterKit
import ThryvUXComponents
import FunkyNetwork

enum LoginCall: THUXCredsLoginNetworkCall {
    lazy var authResponseSignal = self.dataSignal.skipNil().map(LoginCall.parse).skipNil()
    public static let ApiKeyPref = "api_key"
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: configuration, wrapKey: nil, stubHolder: stubHolder)
        usernameKey = "access_token"
        passwordKey = "access_token_secret"
        
        authResponseSignal.observeValues { user in
            let session = THUXUserDefaultsSession(authDefaultsKey: LoginCall.ApiKeyPref, authHeaderKey: "X-Api-Key")
            session.setAuthValue(authString: user.apiKey ?? "")
            THUXSessionManager.session = session
        }
    }
    
    func login(session: TWTRSession) {
        username = session.authToken
        password = session.authTokenSecret
        
        fire()
    }
    
    static func parse(jsonData: Data) -> User? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let userResponse = try decoder.decode(User.self, from: jsonData)
            return userResponse
        } catch {
            return nil
        }
    }

}
