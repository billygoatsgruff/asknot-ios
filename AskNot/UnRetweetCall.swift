//
//  UnRetweetCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/14/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import LUX
import FunNet

class UnRetweetCall: THUXAuthenticatedNetworkCall {
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, tweetId: Int, stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: configuration, httpMethod: "DELETE", httpHeaders: [:], endpoint: "retweets/\(tweetId)", postData: nil, stubHolder: nil)
    }

}
