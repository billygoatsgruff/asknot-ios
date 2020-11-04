//
//  UpdateProfileCall.swift
//  AskNot
//
//  Created by Elliot Schrock on 10/17/18.
//  Copyright © 2018 billygoatsgruff. All rights reserved.
//

import UIKit
import LUX
import FunNet

class UpdateProfileCall: THUXModelCall<UserResponse> {
    public lazy var userSignal = modelSignal.map { $0.user }.skipNil()
    
    init(configuration: ServerConfigurationProtocol = AskNotServerConfig.current, hasShared: Bool? = nil, isSupporter: Bool? = nil, stubHolder: StubHolderProtocol? = nil) {
        var json = [String: AnyObject]()
        if let hasShared = hasShared {
            json["has_shared"] = hasShared as AnyObject
        }
        if let isSupporter = isSupporter {
            json["is_supporter"] = isSupporter as AnyObject
        }
        json = ["user": json as AnyObject]
        let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        super.init(configuration: configuration, httpMethod: "PUT", httpHeaders: [:], endpoint: "current_user", postData: data, stubHolder: stubHolder)
    }

}
