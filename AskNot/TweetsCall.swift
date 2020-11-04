//
//  TweetsCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 2/9/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import LUX
import FunNet

class TweetsCall: THUXModelCall<TweetIdsResponse> {
    public lazy var tweetIdsSignal = modelSignal.map { $0.tweets }.skipNil()
    
    init(stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: AskNotServerConfig.current, httpMethod: "GET", httpHeaders: [:], endpoint: "tweets", postData: nil, stubHolder: stubHolder)
    }
}
