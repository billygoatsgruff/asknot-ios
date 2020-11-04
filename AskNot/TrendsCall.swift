//
//  TrendsCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 3/6/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import LUX
import FunNet

class TrendsCall: THUXModelCall<TrendsResponse> {
    public lazy var trendsSignal = modelSignal.map { $0.trends }.skipNil()
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: configuration, httpMethod: "GET", httpHeaders: [:], endpoint: "trends", postData: nil, stubHolder: stubHolder)
    }

}
