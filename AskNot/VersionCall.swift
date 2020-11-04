//
//  VersionCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 8/21/17.
//  Copyright © 2017 billygoatsgruff. All rights reserved.
//

import UIKit
import FunNet

class VersionCall: JsonNetworkCall {
    public lazy var versionSignal = jsonSignal.map(VersionCall.parse)
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, stubHolder: StubHolderProtocol? = nil) {
        super.init(configuration: configuration, httpMethod: "GET", endpoint: "version", postData: nil, stubHolder: stubHolder)
    }
    
    static func parse(json: Any) -> String {
        return ((json as? [String: AnyObject])?["version"] as? String) ?? "10000"
    }
}
